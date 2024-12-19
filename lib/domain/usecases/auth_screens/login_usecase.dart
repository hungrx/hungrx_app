

import 'package:hungrx_app/data/Models/auth_screens/login_model.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_signin_repository.dart';

class LoginUseCase {
  final UserSignInRepository repository;

  LoginUseCase(this.repository);

  Future<String> execute(String email, String password) async {
    final loginModel = LoginModel(email: email, password: password);

    return await repository.login(loginModel);
  }
}
