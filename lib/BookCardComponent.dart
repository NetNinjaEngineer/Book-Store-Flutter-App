import 'package:flutter/material.dart';
import 'package:helloworld/book.model.dart';

class BookCardComponent extends StatelessWidget {
  final Book book;
  const BookCardComponent({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image in the first row
            Container(
              height: 200,
              width: double.infinity,
              child: Image.network(
                book.imageUrl ??
                    '',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                book.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              book.authors.join(','),
              style: const TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Genre: ${book.genre}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${book.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
