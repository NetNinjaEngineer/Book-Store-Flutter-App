import 'package:dio/dio.dart';
import 'package:helloworld/Models/AuthorModel.dart';
import 'package:helloworld/Models/GenreModel.dart';
import 'package:helloworld/API/TokenService.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String?> getJwtToken() async {
    return await TokenService().getToken();
  }

  Future<Map<String, dynamic>> getHeaders() async {
    Map<String, dynamic> headers = {
      "Authorization": "Bearer ${await getJwtToken()}",
      "Content-Type": "application/json"
    };
    return headers;
  }

  Future<List<Book>> getBooks() async {
    try {
      Dio dio = Dio();

      var response = await dio.get('https://localhost:7035/api/Books',
          options: Options(headers: await getHeaders()));

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

      var response = await dio.get('https://localhost:7035/api/Authors',
          options: Options(headers: await getHeaders()));

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

      var response = await dio.get('https://localhost:7035/api/Genres',
          options: Options(headers: await getHeaders()));

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
    var url = Uri.parse('https://localhost:7035/api/Books/$id');

    var response = await http.delete(url, headers: {
      "Authorization": "Bearer ${await TokenService().getToken()}",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 204) {
      return "Book with ID: $id deleted successfully";
    } else {
      throw Exception('Failed to delete book');
    }
  }
}
