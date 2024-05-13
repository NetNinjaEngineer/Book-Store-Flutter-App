import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:helloworld/Screens/AdminScreens/show_all_books_page.dart';
import 'package:helloworld/cubit/books_cubit.dart';

// ignore: must_be_immutable
class EditBookPage extends StatefulWidget {
  Book book;
  EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _publicationYearController =
      TextEditingController();

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.book.title.toString();
    _priceController.text = widget.book.price.toString();
    _publicationYearController.text = widget.book.publicationYear.toString();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.book.title}"),
      ),
      body: Center(
        child: Padding(
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
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellowAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 20)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(16.0))),
                  onPressed: () {
                    BooksCubit cubit = BlocProvider.of(context);
                    widget.book.title = _titleController.text;

                    if (double.tryParse(_priceController.text) != null) {
                      widget.book.price = double.parse(_priceController.text);
                    }

                    if (int.tryParse(_publicationYearController.text) != null) {
                      widget.book.publicationYear =
                          int.parse(_publicationYearController.text);
                    }

                    cubit.updateBook(widget.book, _imageBytes);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const ShowAllBooksPage();
                    }));
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
