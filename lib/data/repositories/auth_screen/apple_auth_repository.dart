import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungrx_app/data/datasources/api/auth_screen.dart/apple_auth_api.dart';
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
          clientId: 'com.hungrx.signin',  // Updated to match the aud claim
          redirectUri: Uri.parse(
            'https://hungrx-app.firebaseapp.com/__/auth/handler',
          ),
        ),
        nonce: nonce,
      );

      // Debug information
      // print('Identity Token: ${appleCredential.identityToken?.substring(0, 50)}...');
      // print('Authorization Code: ${appleCredential.authorizationCode.substring(0, 50)}...');
      print('User ID: ${appleCredential.email}');
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
        print('First sign-in attempt failed, trying alternative method...');

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
            await _api.loginWithApple(
              idToken: appleCredential.identityToken!,
              authCode: appleCredential.authorizationCode,
             
            );
          } catch (e) {
            print('Backend API error (non-fatal): $e');
          }

          return userCredential;
        } on FirebaseAuthException catch (e) {
          print('Detailed Firebase Auth Error:');
          print('Code: ${e.code}');
          print('Message: ${e.message}');
          print('Email: ${e.email}');
          print('Credential: ${e.credential}');
          print('Tenant ID: ${e.tenantId}');
          rethrow;
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      print('Apple Sign In Authorization Error:');
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error during Apple Sign In: $e');
      rethrow;
    }
  }
}
