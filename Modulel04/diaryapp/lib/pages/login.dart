// pages/login.dart
import 'package:flutter/material.dart';
import '../services/'; // Import the GoogleSignIn instance
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleSignIn,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
