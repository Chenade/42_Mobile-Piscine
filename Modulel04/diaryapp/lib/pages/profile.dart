import 'package:flutter/material.dart';
import '../services/google.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = GoogleSignInService.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Please sign in to view your profile'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                  onPressed: () async {
                    await GoogleSignInService.signOut();
                    Navigator.pushReplacementNamed(context, '/');
                  }
                  , child: const Text('Sign In'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL ?? ''),
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(user.displayName  ?? '',
                      style: const TextStyle(fontSize: 20)),
                  Text(user.email ?? ""),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await GoogleSignInService.signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}
