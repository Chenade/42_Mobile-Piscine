// google_sign_in_provider.dart
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: '86189083537-pg755qn4sr4ornrser88295n1j89mc1h.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
