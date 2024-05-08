import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helloworld/API/ApiService.dart';
import 'package:helloworld/cubit/books_cubit.dart';
import 'package:helloworld/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BooksCubit(ApiService()),
        child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Book store',
            home: LoginPage()));
  }
}
