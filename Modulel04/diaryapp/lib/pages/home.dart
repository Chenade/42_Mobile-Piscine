import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google.dart';

class HomePage extends StatelessWidget {
  final GoogleSignInAccount? user;

  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              user != null
                  ? 'Welcome, ${user!.displayName}!'
                  : 'Welcome to the Home Page!',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  Navigator.pushNamed(context, '/');
                }
              },
              child: Text(user != null ? 'Go to Profile' : 'Login'),
            ),
            if (user != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await GoogleSignInService.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('Sign Out'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
