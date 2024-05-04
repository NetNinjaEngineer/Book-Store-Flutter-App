// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helloworld/CreateBookForm.dart';

class CreateBookPage extends StatelessWidget {
  const CreateBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Book'),
      ),
      body: Center(
        child: CreateBookForm(),
      ),
    );
  }
}
