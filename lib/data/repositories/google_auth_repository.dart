import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  Future<User?> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await _storeUserInDatabase(user);
      }

      return user;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  Future<String> _storeUserInDatabase(User user) async {
    try {
      final url =
          Uri.parse('https://hungerxapp.onrender.com/users/signup/google');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'googleId': user.uid,
          'email': user.email,
          'name': user.displayName,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user') &&
            responseData['user'] is Map<String, dynamic> &&
            responseData['user'].containsKey('id')) {
          final userId = responseData['user']['id'] as String;
          await _saveUserId(userId);
          return userId;
        } else {
          throw Exception(
              'Invalid response format: user ID not found in expected location');
        }
      } else {
        throw Exception(
            'Failed to store user in database. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> _saveUserId(String userId) async {
    print("Saving user ID: $userId");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
    } catch (error) {
      print('Error signing out from Google: $error');
    }
  }
}
