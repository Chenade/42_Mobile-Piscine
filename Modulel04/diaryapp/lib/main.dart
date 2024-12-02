import 'package:flutter/material.dart';
import 'services/google.dart';
import 'pages/login.dart';
// import 'pages/home.dart';
import 'pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GoogleSignInService.signInSilently(); // Attempt silent sign-in before app launch

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = GoogleSignInService.currentUser;

    if (user != null) {
      return const ProfilePage();
    }
    return const LoginPage();
  }
}