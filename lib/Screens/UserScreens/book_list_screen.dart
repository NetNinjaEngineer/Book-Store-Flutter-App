import 'package:flutter/material.dart';
import 'package:helloworld/API/ApiService.dart';
import 'package:helloworld/Screens/UserScreens/book_list_view.dart';
import 'package:helloworld/Models/book.model.dart';

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
    future = ApiService().getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
        backgroundColor: Colors.blue,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) {
        //         return SearchBookScreen();
        //       }));
        //     },
        //     icon: Icon(Icons.search),
        //   )
        // ],
      ),
      body: FutureBuilder<List<Book>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BookListView(books: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error.toString()}");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
