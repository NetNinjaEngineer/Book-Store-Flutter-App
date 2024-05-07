// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helloworld/Screens/AdminScreens/create_book_form.dart';

class CreateBookPage extends StatelessWidget {
  const CreateBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Book'),
      ),
      body: const Center(
        child: CreateBookForm(),
      ),
    );
  }
}
