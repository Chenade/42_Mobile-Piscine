import 'package:flutter/material.dart';

import 'package:auth0_flutter/auth0_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';

import 'pages/home.dart';
import 'pages/login.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Auth0 auth0 = 
    Auth0(
      'dev-aelqdrh6hx6twsln.us.auth0.com', 
      'Hp4TXE3RoGlwr5QSWOmA6a0Mpvs0EeUB'
    );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CheckLogin(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key? key}) : super(key: key);

  void _checkAndRedirect(BuildContext context) async {
    Navigator.of(context).pushNamed('/login');

    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   Navigator.of(context).pushReplacementNamed('/home');
    // } else {
    //   Navigator.of(context).pushNamed('/login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Login'),
          onPressed: () => _checkAndRedirect(context),
        ),
      ),
    );
  }
}
