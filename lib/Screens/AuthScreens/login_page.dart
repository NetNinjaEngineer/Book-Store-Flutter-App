import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:helloworld/API/TokenService.dart';
import 'package:helloworld/Screens/AdminScreens/admin_home_screen.dart';
import 'package:helloworld/Screens/AuthScreens/signup.dart';
import 'package:helloworld/Screens/UserScreens/book_list_screen.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Flag for loading state

  Future<void> _loginUser(String email, String password) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final Map<String, dynamic> userData = {
      'email': email,
      'password': password,
    };

    final Uri url = Uri.parse('https://localhost:7035/api/Auth/Login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      // Login successful
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // store the token
      await TokenService().storeToken(responseData['token']);

      if (responseData['roles'].toString().contains('Admin')) {
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomeScreen(),
            ));
      } else {
        // route user to home page
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const BookListScreen(),
          ),
        );
      }
    } else {
      // Login failed
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${response.body}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   'https://plus.unsplash.com/premium_photo-1703701580104-43fb3013075a?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  //   height: 100,
                  //   width: 100,
                  // ),
                  const SizedBox(height: 20),
                  EmailInput(controller: _emailController),
                  const SizedBox(height: 20),
                  PasswordInput(controller: _passwordController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        await _loginUser(email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child:
                        const Text('Register', style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Separate widgets for each UI component (EmailInput and PasswordInput)
class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      style: const TextStyle(fontSize: 18),
      validator:
          ValidationBuilder().email('Please enter a valid email').build(),
    );
  }
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      style: const TextStyle(fontSize: 18),
      validator:
          ValidationBuilder().required('Please enter your password').build(),
    );
  }
}
