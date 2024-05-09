import 'package:helloworld/Models/book.model.dart';

abstract class BookState {}

class InitBookState extends BookState {}

class LoadingBookState extends BookState {}

class ResponseBookState extends BookState {
  List<Book> books;
  ResponseBookState(this.books);
}

class ErrorBookState extends BookState {
  String message;
  ErrorBookState(this.message);
}

class OnUpdatedBookState extends BookState {
  List<Book> newList;
  OnUpdatedBookState(this.newList);
}

class OnUpdatedBookErrorState extends BookState {
  String message;
  OnUpdatedBookErrorState(this.message);
}
