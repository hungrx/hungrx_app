import 'package:hungrx_app/data/Models/auth_screens/email_model.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_sign_up_repository.dart';

class SignUpUseCase {
  final UserSignUpRepository repository;

  SignUpUseCase(this.repository);

  Future<ApiResponse> execute(String email, String password) async {
    final user = User(email: email, password: password);
    return await repository.signUp(user);
  }
}
