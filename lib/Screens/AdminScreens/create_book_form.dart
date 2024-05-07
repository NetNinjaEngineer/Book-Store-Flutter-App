import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/API/ApiService.dart';
import 'package:helloworld/API/TokenService.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:http_parser/http_parser.dart';

class CreateBookForm extends StatefulWidget {
  const CreateBookForm({super.key});

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<CreateBookForm> {
  Uint8List? _imageBytes;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _publicationYearController =
      TextEditingController();
  int? _selectedGenreId;
  int? _selectedAuthorId;
  List<String> authorNames = [];
  List<String> genreNames = [];
  Map<int, String> authorIdMap = {};
  Map<int, String> genreIdMap = {};

  @override
  void initState() {
    super.initState();
    getAuthorNames();
    getGenreNames();
  }

  // Future<Uint8List?> pickImage() async {
  //   Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  //   return bytesFromPicker;
  // }

  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final List<html.File> files = uploadInput.files!;
      if (files.isNotEmpty) {
        final html.File file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onError.listen((error) {
          // Handle error
        });

        await reader.onLoad.first;

        setState(() {
          _imageBytes = reader.result as Uint8List?;
        });

        // Remove the event listener after processing the file
        uploadInput.remove();
      }
    });
  }

  // void _pickImage() async {
  //   Uint8List? image = await pickImage();
  //   setState(() {
  //     _pickedImage = image;
  //   });
  // }

  Future<void> getGenreNames() async {
    try {
      var genres = await ApiService().getAllGenres();
      Map<int, String> genreIds = {};
      for (var genre in genres) {
        genreIds[genre.id] = genre.genreName;
      }
      setState(() {
        genreNames = genres
            .map((e) => e.genreName)
            .toList(); // Keep the list of genre objects for other uses
        genreIdMap =
            genreIds; // Assuming genreIdMap is a class member to hold the map
      });
    } catch (e) {
      throw Exception('Error fetching genres: $e');
    }
  }

  Future<void> getAuthorNames() async {
    try {
      var authors = await ApiService().getAllAuthors();
      Map<int, String> authorIds = {};
      for (var author in authors) {
        authorIds[author.id] = author.authorName;
      }
      setState(() {
        authorNames = authors
            .map((e) => e.authorName)
            .toList(); // Keep the list of author objects for other uses
        authorIdMap =
            authorIds; // Assuming authorIdMap is a class member to hold the map
      });
    } catch (e) {
      throw Exception('Error fetching authors: $e');
    }
  }

  Future<http.StreamedResponse> uploadImage() async {
    var jwtToken = await TokenService().getToken();
    var url = Uri.parse('https://localhost:7035/api/Books');

    var request = http.MultipartRequest('POST', url);

    request.headers['Content-Type'] = 'multipart/form-data; charset=utf-8';
    request.headers['Authorization'] = 'Bearer $jwtToken';

    request.fields['title'] = _titleController.text;
    request.fields['genreId'] =
        _selectedGenreId != null ? _selectedGenreId.toString() : '';
    request.fields['authorId'] =
        _selectedAuthorId != null ? _selectedAuthorId.toString() : '';
    request.fields['price'] = _priceController.text;
    request.fields['publicationYear'] = _publicationYearController.text;

    request.files.add(http.MultipartFile.fromBytes('image', _imageBytes!,
        filename: 'images.png', contentType: MediaType.parse('image/*')));

    return await request.send();
  }

  Future<void> _submitForm() async {
    try {
      // Upload image and get response
      var response = await uploadImage();

      // Check if image upload was successful
      if (response.statusCode == 422) {
        // If the status code is 422, print the response body for debugging
        print('Received 422 Unprocessable Entity response');
        print('Response body: ${await response.stream.bytesToString()}');
      } else if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book created successfully')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    } catch (e) {
      print('Error creating book: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating book: $e')),
      );
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
              if (_imageBytes != null)
                Image.memory(
                  _imageBytes!,
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
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
              DropdownButtonFormField<int>(
                value: _selectedGenreId,
                hint: const Text('Select Genre'),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedGenreId = newValue; // Store the ID
                  });
                },
                items: genreIdMap.entries
                    .map<DropdownMenuItem<int>>((MapEntry<int, String> entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<int>(
                value: _selectedAuthorId,
                hint: const Text('Select Author'),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedAuthorId = newValue; // Store the ID
                  });
                },
                items: authorIdMap.entries
                    .map<DropdownMenuItem<int>>((MapEntry<int, String> entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
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
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _submitForm();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
