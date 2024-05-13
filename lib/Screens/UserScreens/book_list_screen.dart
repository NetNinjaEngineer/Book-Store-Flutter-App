import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helloworld/API/api_service.dart';
import 'package:helloworld/Screens/UserScreens/book_list_view.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:helloworld/cubit/book_states.dart';
import 'package:helloworld/cubit/books_cubit.dart';
import 'package:helloworld/shortcuts/logout_button.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  bool _isSearching = false;
  String _searchText = '';

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _searchText = ''; // Reset search term on start
    });
  }

  void _endSearch() {
    setState(() {
      _isSearching = false;
      _searchText = ''; // Reset search term on end
      BooksCubit cubit = BlocProvider.of(context);
      cubit.fetchAllBooks();
    });
  }

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
          title: _isSearching
              ? TextField(
                  controller: TextEditingController(text: _searchText),
                  autocorrect: true,
                  autofocus: true,
                  enableSuggestions: true,
                  textDirection: TextDirection.ltr,
                  mouseCursor: MouseCursor.defer,
                  decoration: const InputDecoration(
                    hintText: 'Search books...',
                    border: InputBorder.none,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _searchText = value;
                    });
                    // Implement search logic based on _searchText (explained later)
                    BooksCubit cubit = BlocProvider.of(context);
                    cubit.onSearchBooks(_searchText);
                  },
                )
              : const Text('Book List'),
          backgroundColor: Colors.blue,
          actions: [
            _isSearching
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _endSearch,
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _startSearch,
                  ),
            const LogoutButton()
          ],
        ),
        body: BlocBuilder<BooksCubit, BookState>(builder: (context, state) {
          if (state is InitBookState || state is LoadingBookState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResponseBookState) {
            return BookListView(books: state.books);
          } else if (state is ErrorBookState) {
            return Center(child: Text(state.message));
          } else if (state is OnSearchedBooksState) {
            return BookListView(books: state.books);
          }
          return const Center(child: Text('Something went wrong...'));
        }));
  }
}
