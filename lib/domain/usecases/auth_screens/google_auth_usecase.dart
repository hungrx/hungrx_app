import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';

class GoogleAuthUseCase {
  final GoogleAuthRepository repository;

  GoogleAuthUseCase(this.repository);

  Future<User?> signIn() async {
    return await repository.signIn();
  }

  Future<void> signOut() async {
    await repository.signOut();
  }
}