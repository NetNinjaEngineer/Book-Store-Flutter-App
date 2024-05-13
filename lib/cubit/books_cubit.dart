import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/API/api_service.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:helloworld/cubit/book_states.dart';

class BooksCubit extends Cubit<BookState> {
  final ApiService apiService;
  BooksCubit(this.apiService) : super(InitBookState());

  fetchAllBooks() async {
    emit(LoadingBookState());

    try {
      final response = await apiService.getBooks();
      emit(ResponseBookState(response));
    } catch (e) {
      emit(ErrorBookState(e.toString()));
    }
  }

  updateBook(Book book, Uint8List? image) async {
    try {
      await ApiService().updateBook(book, image);
      var books = await ApiService().getBooks();
      emit(OnUpdatedBookState(books));
    } catch (e) {
      emit(OnUpdatedBookErrorState(e.toString()));
    }
  }

  onDeleteBook(int id) async {
    try {
      await ApiService().deleteBook(id);
      var books = await ApiService().getBooks();
      emit(OnDeletedBookState(books));
    } catch (e) {
      emit(OnDeletedBookErrorState(e.toString()));
    }
  }

  onSearchBooks(String searchValue) async{
    try {
      var searedBooks = await ApiService().searchBooks(searchValue);
      emit(OnSearchedBooksState(searedBooks));
    } catch (e) {
      throw Exception(e);
    }
  }
}
