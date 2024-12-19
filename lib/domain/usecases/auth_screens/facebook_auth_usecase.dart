

import 'package:hungrx_app/data/repositories/auth_screen/facebook_auth_repository.dart';

class FacebookAuthUseCase {
  final FacebookAuthRepository repository;

  FacebookAuthUseCase(this.repository);

  Future<String> execute() async {
    return await repository.signInWithFacebook();
  }

  Future<void> signOut() async {
    await repository.signOut();
  }
}