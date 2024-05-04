import 'package:dio/dio.dart';
import 'package:helloworld/AuthorModel.dart';
import 'package:helloworld/GenreModel.dart';
import 'package:helloworld/TokenService.dart';
import 'package:helloworld/book.model.dart';
import 'package:http/http.dart' as http;

class ApiService {
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

  Future<List<Author>> getAllAuthors() async {
    try {
      Dio dio = Dio();

      Map<String, dynamic> headers = {
        "Authorization": "Bearer ${await TokenService().getToken()}",
        "Content-Type": "application/json"
      };

      var response = await dio.get('https://localhost:7035/api/Authors',
          options: Options(headers: headers));

      List<Map<String, dynamic>> jsonData =
          List<Map<String, dynamic>>.from(response.data);

      List<Author> authors = [];

      for (var book in jsonData) {
        authors.add(Author.fromJson(book));
      }

      return authors;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

   Future<List<Genre>> getAllGenres() async {
    try {
      Dio dio = Dio();

      Map<String, dynamic> headers = {
        "Authorization": "Bearer ${await TokenService().getToken()}",
        "Content-Type": "application/json"
      };

      var response = await dio.get('https://localhost:7035/api/Genres',
          options: Options(headers: headers));

      List<Map<String, dynamic>> jsonData =
          List<Map<String, dynamic>>.from(response.data);

      List<Genre> genres = [];

      for (var genre in jsonData) {
        genres.add(Genre.fromJson(genre));
      }

      return genres;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }


  Future<String> deleteBook(int id) async {
    final Map<String, String> headers = {
      "Authorization": "Bearer ${await TokenService().getToken()}",
      "Content-Type": "application/json"
    };

    var url = Uri.parse('https://localhost:7035/api/Books/${id}');

    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      return "Book with ID: ${id} deleted successfully";
    } else {
      throw Exception('Failed to delete book');
    }
  }
}
