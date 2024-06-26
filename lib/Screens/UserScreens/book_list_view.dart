import 'package:flutter/material.dart';
import 'package:helloworld/Screens/UserScreens/book_card_component.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:helloworld/Screens/UserScreens/book_details_page.dart';

class BookListView extends StatelessWidget {
  final List<Book>? books;
  const BookListView({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookDetailsPage(
                                bookId: books![index].bookId,
                                title: books![index].title,
                                authors: books![index].authors,
                                genre: books![index].genre,
                                imageUrl: books![index].imageUrl,
                                price: books![index].price,
                                publicationYear: books![index].publicationYear,
                              )))
                },
            child: BookCardComponent(book: books![index]));
      },
    );
  }
}
