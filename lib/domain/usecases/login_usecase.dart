import '../../data/models/login_model.dart';
import '../../data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> execute(String email, String password) async {
    final loginModel = LoginModel(email: email, password: password);
    
    return await repository.login(loginModel);
  }
}