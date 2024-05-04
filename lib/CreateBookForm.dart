import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helloworld/ApiService.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreateBookForm extends StatefulWidget {
  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<CreateBookForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _publicationYearController = TextEditingController();
  String? _selectedGenreId;
  String? _selectedAuthorId;
  File? _imageFile;
  List<String> authorNames = [];
  List<String> genreNames = [];

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Or ImageSource.camera
    );
    setState(() {
      _pickedImage = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call getAuthorNames() when the widget initializes
    getAuthorNames();
    getGenreNames();
  }

  Future<void> getGenreNames() async {
    try {
      var genres = await ApiService().getAllGenres();
      var names = genres.map((e) => e.genreName).toList();
      setState(() {
        genreNames = names;
      });
    } catch (e) {
      // Handle error
      throw Exception('Error fetching genres: $e');
    }
  }

  Future<void> getAuthorNames() async {
    try {
      var authors = await ApiService().getAllAuthors();
      var names = authors.map((e) => e.authorName).toList();
      setState(() {
        authorNames = names;
      });
    } catch (e) {
      // Handle error
      throw Exception('Error fetching authors: $e');
    }
  }

  Future<void> _submitForm() async {
    XFile? image;

    if (_formKey.currentState!.validate()) {
      // Form is valid, send data to API
      var url = Uri.parse('https://localhost:7035/api/Books');
      var request = http.MultipartRequest('POST', url);
      request.fields['title'] = _titleController.text;
      request.fields['genreId'] = _selectedGenreId!;
      request.fields['authorId'] = _selectedAuthorId!;
      request.fields['price'] = _priceController.text;
      request.fields['publicationYear'] = _publicationYearController.text;
      request.files.add(await http.MultipartFile.fromBytes(
        'image',
        await image!.readAsBytes(),
        filename: image.name
      )); 

      var response = await request.send();
      if (response.statusCode == 200) {
        // Success
        print('Form submitted successfully');
      } else {
        // Error
        print('Form submission failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedGenreId,
                hint: const Text('Select Genre'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGenreId = newValue;
                  });
                },
                items: genreNames // Replace with your genre list
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: _selectedAuthorId,
                hint: const Text('Select Author'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAuthorId = newValue;
                  });
                },
                items:
                    authorNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value, // Assuming value is the author ID
                    child: Text(value), // Display author name
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _publicationYearController,
                decoration:
                    const InputDecoration(labelText: 'Publication Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter publication year';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 10,
              ),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
