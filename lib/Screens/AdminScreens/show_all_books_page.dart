// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helloworld/API/ApiService.dart';
import 'package:helloworld/Models/book.model.dart';

class ShowAllBooksPage extends StatefulWidget {
  const ShowAllBooksPage({super.key});

  @override
  State<ShowAllBooksPage> createState() => _ShowAllBooksPageState();
}

class _ShowAllBooksPageState extends State<ShowAllBooksPage> {
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
          title: const Text('All Books'),
        ),
        body: FutureBuilder<List<Book>>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                        snapshot.data![index].imageUrl.toString()),
                    title: Text(snapshot.data![index].title.toString()),
                    subtitle: Text('${snapshot.data![index].price} \$ '),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          onPressed: () => {},
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.yellow,
                          )),
                      Builder(builder: (context) {
                        return IconButton(
                            onPressed: () async {
                              var message = await ApiService()
                                  .deleteBook(snapshot.data![index].bookId);
                              if (message.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } else {}
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ));
                      })
                    ]),
                  );
                },
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            } else {
              return const Center(
                child: Text('There is no data loaded'),
              );
            }
          },
          future: future,
        ));
  }
}
