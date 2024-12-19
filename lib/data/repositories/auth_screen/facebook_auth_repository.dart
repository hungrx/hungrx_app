import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class FacebookAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<String> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        final String? idToken = await userCredential.user?.getIdToken();

        if (idToken != null) {
          final response = await http.post(
            Uri.parse('https://hungerxapp.onrender.com/users/signup/facebook'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'idToken': idToken}),
          );

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            return responseData['token'];
          } else {
            throw Exception('Failed to authenticate with the server');
          }
        } else {
          throw Exception('Failed to get ID token');
        }
      } else {
        throw Exception('Facebook login failed');
      }
    } catch (e) {
      throw Exception('Facebook sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _facebookAuth.logOut();
  }
}