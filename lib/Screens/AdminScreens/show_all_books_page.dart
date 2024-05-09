// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helloworld/API/ApiService.dart';
import 'package:helloworld/Models/book.model.dart';
import 'package:helloworld/Screens/AdminScreens/EditBookPage.dart';
import 'package:helloworld/cubit/book_states.dart';
import 'package:helloworld/cubit/books_cubit.dart';

class ShowAllBooksPage extends StatefulWidget {
  const ShowAllBooksPage({super.key});

  @override
  State<ShowAllBooksPage> createState() => _ShowAllBooksPageState();
}

class _ShowAllBooksPageState extends State<ShowAllBooksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BooksCubit>();
      cubit.fetchAllBooks();
    });
  }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to delete this?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Books'),
        ),
        body: BlocBuilder<BooksCubit, BookState>(builder: (context, state) {
          if (state is InitBookState || state is LoadingBookState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResponseBookState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      Image.network(state.books[index].imageUrl.toString()),
                  title: Text(state.books[index].title.toString()),
                  subtitle: Text('${state.books[index].price} \$ '),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditBookPage(book: state.books[index]);
                              }))
                            },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.yellow,
                        )),
                    Builder(builder: (context) {
                      return IconButton(
                          onPressed: () async {
                            final confirmed =
                                await showConfirmationDialog(context);

                            if (confirmed == true) {
                              var message = await ApiService()
                                  .deleteBook(state.books[index].bookId);

                              if (message.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
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
              itemCount: state.books.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else if (state is ErrorBookState) {
            return Center(child: Text(state.message));
          } else if (state is OnUpdatedBookState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      Image.network(state.newList[index].imageUrl.toString()),
                  title: Text(state.newList[index].title.toString()),
                  subtitle: Text('${state.newList[index].price} \$ '),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditBookPage(book: state.newList[index]);
                              }))
                            },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.yellow,
                        )),
                    Builder(builder: (context) {
                      return IconButton(
                          onPressed: () async {
                            var message = await ApiService()
                                .deleteBook(state.newList[index].bookId);
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
              itemCount: state.newList.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }

          return const Center(child: Text('Something went wrong...'));
        }));
  }
}
