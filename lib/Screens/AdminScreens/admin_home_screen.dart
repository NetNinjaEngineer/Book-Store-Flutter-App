import 'package:flutter/material.dart';
import 'package:helloworld/API/TokenService.dart';
import 'package:helloworld/Screens/AdminScreens/create_book_page.dart';
import 'package:helloworld/Screens/AdminScreens/show_all_books_page.dart';
import 'package:helloworld/Screens/AuthScreens/login_page.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin Page'),
          backgroundColor: Colors.lightBlue,
          actions: [
            ElevatedButton(
              onPressed: () async {
                await TokenService().removeToken();

                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Logout'),
            )
          ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateBookPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 60),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('Create Book')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShowAllBooksPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 60),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Show All Books'),
            )
          ],
        ),
      ),
    );
  }
}
