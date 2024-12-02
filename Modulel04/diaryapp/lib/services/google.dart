import 'dart:async';
// import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;

class GoogleSignInService {
  static const List<String> _scopes = <String>[
    'email',
    // 'https://www.googleapis.com/auth/contacts.readonly',
  ];

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '786189083537-pg755qn4sr4ornrser88295n1j89mc1h.apps.googleusercontent.com',
    scopes: _scopes,
  );

  static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  static Stream<GoogleSignInAccount?> get onCurrentUserChanged =>
      _googleSignIn.onCurrentUserChanged;

  static Future<void> signInSilently() => _googleSignIn.signInSilently();

  static Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('Error signing in: $error');
    }
  }

  static Future<void> signOut() => _googleSignIn.disconnect();

  static Future<bool> requestScopes() async {
    try {
      return await _googleSignIn.requestScopes(_scopes);
    } catch (error) {
      debugPrint('Error requesting scopes: $error');
      return false;
    }
  }

  // static Future<String?> fetchFirstContact() async {
  //   final GoogleSignInAccount? user = _googleSignIn.currentUser;
  //   if (user == null) return null;

  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //           '?requestMask.includeField=person.names'),
  //       headers: await user.authHeaders,
  //     );

  //     if (response.statusCode != 200) {
  //       debugPrint(
  //           'Error fetching contacts: ${response.statusCode} ${response.body}');
  //       return null;
  //     }

  //     final Map<String, dynamic> data =
  //         json.decode(response.body) as Map<String, dynamic>;
  //     return _pickFirstNamedContact(data);
  //   } catch (error) {
  //     debugPrint('Error fetching contacts: $error');
  //     return null;
  //   }
  // }

  // static String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'] as List<dynamic>?;
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //     (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
  //     orElse: () => null,
  //   ) as Map<String, dynamic>?;
  //   if (contact != null) {
  //     final List<dynamic> names = contact['names'] as List<dynamic>;
  //     final Map<String, dynamic>? name = names.firstWhere(
  //       (dynamic name) =>
  //           (name as Map<Object?, dynamic>)['displayName'] != null,
  //       orElse: () => null,
  //     ) as Map<String, dynamic>?;
  //     if (name != null) {
  //       return name['displayName'] as String?;
  //     }
  //   }
  //   return null;
  // }
}
