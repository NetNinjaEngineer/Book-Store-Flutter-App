import 'package:bloc/bloc.dart';
import 'package:helloworld/API/ApiService.dart';
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
}
