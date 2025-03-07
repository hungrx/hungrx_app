import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/core/errors/google_auth_error.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Add scopes needed for iOS
    scopes: [
      'email',
      'profile',
    ],
    // Add iOS client ID
    clientId:
        Platform.isIOS ? '487283706527-0dop9npjm3g2rhoajabadjcv32tpf8ab.apps.googleusercontent.com' : null,
  );
  final _auth = FirebaseAuth.instance;

  Future<User?> signIn() async {
    try {
      GoogleSignInAccount? existingUser = _googleSignIn.currentUser;
      GoogleSignInAccount? googleUser;

      if (existingUser != null) {
        // Re-authenticate existing user
        googleUser = await _googleSignIn.signInSilently();
      }
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        throw GoogleAuthException(
          message: 'Sign in cancelled by user',
          isCancelled: true,
        );
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      // print(user);

      if (user != null) {
        await _storeUserInDatabase(user);
        return user;
      } else {
        throw Exception('Failed to get user data from Google Sign In');
      }
    } on PlatformException catch (e) {
      throw GoogleAuthException(
        message: 'Platform error occurred: ${e.message}',
      );
    } catch (e) {
      if (Platform.isIOS) {
        if (e.toString().contains('cancelled')) {
          throw GoogleAuthException(
            message: 'Sign in cancelled by user',
            isCancelled: true,
          );
        }
        if (e.toString().contains('network')) {
          throw GoogleAuthException(
            message: 'Network error occurred. Please check your connection.',
          );
        }
      }

      if (e is GoogleAuthException) {
        rethrow;
      }
      throw GoogleAuthException(
        message: 'Failed to sign in with Google: $e',
      );
    }
  }

  Future<String> _storeUserInDatabase(User user) async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.google);

      final requestBody = {
        'googleId': user.uid,
        'email': user.email,
        'name': user.displayName,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );


      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true &&
            responseData['data'] != null &&
            responseData['data']['user'] != null) {
          final userId = responseData['data']['user']['id'] as String;
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
      // print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> _saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      // print('Successfully saved user ID to SharedPreferences');
    } catch (e) {
      // print('Error saving user ID: $e');
      throw Exception('Failed to save user ID locally');
    }
  }


  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
    } catch (error) {
      throw Exception('Failed to sign out from Google: $error');
    }
  }
}
