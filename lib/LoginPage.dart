// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helloworld/AdminHomeScreen.dart';
import 'package:helloworld/BookListScreen.dart';
import 'package:helloworld/TokenService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:form_validator/form_validator.dart';
import 'package:helloworld/signup.dart'; // Import RegisterPage

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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmailInput(controller: _emailController),
                const SizedBox(height: 20),
                PasswordInput(controller: _passwordController),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            await _loginUser(email, password);
                          }
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
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
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
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
      decoration: const InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
      ),
      validator:
          ValidationBuilder().required('Please enter your password').build(),
    );
  }
}
