import '../../data/models/login_model.dart';
import '../../data/repositories/email_signin_repository.dart';

class LoginUseCase {
  final UserSignInRepository repository;

  LoginUseCase(this.repository);

  Future<String> execute(String email, String password) async {
    final loginModel = LoginModel(email: email, password: password);

    return await repository.login(loginModel);
  }
}
