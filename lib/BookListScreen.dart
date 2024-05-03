import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/BookListView.dart';
import 'package:helloworld/TokenService.dart';
import 'package:helloworld/book.model.dart';
import 'package:http/http.dart' as http;

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  var future;
  @override
  void initState() {
    super.initState();
    future = getBooks();
  }

  Future<List<Book>> getBooks() async {
    try {
      Dio dio = Dio();

      Map<String, dynamic> headers = {
        "Authorization": "Bearer ${await TokenService().getToken()}",
        "Content-Type": "application/json"
      };

      var response = await dio.get('https://localhost:7035/api/Books',
          options: Options(headers: headers));

      List<Map<String, dynamic>> jsonData =
          List<Map<String, dynamic>>.from(response.data);

      List<Book> books = [];

      for (var book in jsonData) {
        books.add(Book.fromJson(book));
      }

      return books;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BookListView(books: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error.toString()}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
