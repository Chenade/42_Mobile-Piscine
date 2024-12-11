import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../services/google.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diary App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Please login with your Google account'),
            const SizedBox(height: 20),
            SignInButton(
              Buttons.google,
              onPressed: () async {
                await GoogleSignInService.signIn();
                if (GoogleSignInService.currentUser != null) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
