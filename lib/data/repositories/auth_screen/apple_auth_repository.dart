import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungrx_app/data/datasources/api/auth_screen.dart/apple_auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class AppleAuthRepository {
  final AppleAuthApi _api;
  final FirebaseAuth _firebaseAuth;

  AppleAuthRepository({
    required AppleAuthApi api,
    FirebaseAuth? firebaseAuth,
  })  : _api = api,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.hungrx.signin', // Updated to match the aud claim
          redirectUri: Uri.parse(
            'https://hungrx-app.firebaseapp.com/__/auth/handler',
          ),
        ),
        nonce: nonce,
      );

      // Debug information
      // print('Identity Token: ${appleCredential.identityToken?.substring(0, 50)}...');
      // print('Authorization Code: ${appleCredential.authorizationCode.substring(0, 50)}...');
      // print('Email: ${appleCredential.email}');
      // print('Given Name: ${appleCredential.givenName}');
      // print('Family Name: ${appleCredential.familyName}');

      if (appleCredential.identityToken == null) {
        throw Exception('Identity token is null');
      }

      // Try creating an AuthCredential first
      final authCredential = AuthCredential(
        providerId: 'apple.com',
        signInMethod: 'oauth',
        accessToken: appleCredential.authorizationCode,
      );

      try {
        // First attempt with AuthCredential
        return await _firebaseAuth.signInWithCredential(authCredential);
      } catch (e) {
        // If first attempt fails, try with OAuthProvider
        final oauthCredential = OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken!,
          rawNonce: rawNonce,
          accessToken: appleCredential.authorizationCode,
        );

        try {
          final userCredential =
              await _firebaseAuth.signInWithCredential(oauthCredential);

          // Only proceed with backend API call if Firebase auth succeeded

          try {
            final apiResponse = await _api.loginWithApple(
              idToken: appleCredential.identityToken!,
              authCode: appleCredential.authorizationCode,
            );

            if (apiResponse.data.user?.id != null) {
              await _saveUserId(apiResponse.data.user!.id);
            }
          } catch (e) {
            throw Exception('Failed to authenticate with backend: $e');
          }

          return userCredential;
        } on FirebaseAuthException catch (e) {
          Exception('Firebase auth failed: $e');
          rethrow;
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      throw Exception('Apple Sign In failed: $e');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
    } catch (e) {
      throw Exception('Failed to save Apple user ID locally');
    }
  }

  // Add this function for sign out
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _firebaseAuth.signOut();

      // Clear stored user ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
    } catch (error) {
      throw Exception('Failed to sign out from Apple: $error');
    }
  }
}
