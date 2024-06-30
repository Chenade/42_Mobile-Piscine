import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import './home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              text: 'Sign in with Google',
              onPressed: () => _signInWithGoogle(),
            ),
            SignInButton(
              Buttons.GitHub,
              text: 'Sign in with Github',
              onPressed: () => _signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];


      GoogleSignIn _googleSignIn = GoogleSignIn(
        // Optional clientId
        // clientId: 'your-client_id.apps.googleusercontent.com',
        scopes: scopes,
      );
      try {
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    // try {
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn(
    //     scopes: scopes
    //   );
    //   if (googleUser != null) {
    //     final GoogleSignInAuthentication googleAuth =
    //         await googleUser.authentication;
    //     final OAuthCredential credential = GoogleAuthProvider.credential(
    //       accessToken: googleAuth.accessToken,
    //       idToken: googleAuth.idToken,
    //     );
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    //     if (mounted) {
    //       Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => const HomePage()),
    //         (Route<dynamic> route) => false,
    //       );
    //     }
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
}
