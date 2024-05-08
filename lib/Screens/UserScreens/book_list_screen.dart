import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helloworld/API/ApiService.dart';
import 'package:helloworld/Screens/UserScreens/book_list_view.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:helloworld/cubit/book_states.dart';
import 'package:helloworld/cubit/books_cubit.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BooksCubit>();
      cubit.fetchAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book List'),
          backgroundColor: Colors.blue,
        ),
        body: BlocBuilder<BooksCubit, BookState>(builder: (context, state) {
          if (state is InitBookState || state is LoadingBookState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResponseBookState) {
            return BookListView(books: state.books);
          } else if (state is ErrorBookState) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong...'));
        }));
  }
}
