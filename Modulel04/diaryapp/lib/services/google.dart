import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static const List<String> _scopes = <String>[
    'email',
  ];

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '87957247657-p9rdiu8sn5c29nn80vgpmmuni3jbglle.apps.googleusercontent.com',
    scopes: _scopes,
  );
  static User? get currentUser => FirebaseAuth.instance.currentUser;
  // static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  static Stream<GoogleSignInAccount?> get onCurrentUserChanged =>
      _googleSignIn.onCurrentUserChanged;

  static Future<void> signInSilently() => _googleSignIn.signInSilently();

  static Future<void> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return ;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (error) {
      debugPrint('Error signing in: $error');
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  static Future<bool> requestScopes() async {
    try {
      return await _googleSignIn.requestScopes(_scopes);
    } catch (error) {
      debugPrint('Error requesting scopes: $error');
      return false;
    }
  }
}
