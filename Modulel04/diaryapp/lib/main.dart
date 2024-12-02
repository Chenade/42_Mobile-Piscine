import 'dart:developer';

import 'package:flutter/material.dart';
import 'services/google.dart';
import 'pages/login.dart';
// import 'pages/home.dart';
import 'pages/profile.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });


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