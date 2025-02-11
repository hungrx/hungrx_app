import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungrx_app/data/repositories/auth_screen/apple_auth_repository.dart';

class AppleSignInUseCase {
  final AppleAuthRepository _repository;

  AppleSignInUseCase(this._repository);

  Future<UserCredential> execute() async {
    return await _repository.signInWithApple();
  }
   Future<void> signOut() async {
    await _repository.signOut();
  }
}