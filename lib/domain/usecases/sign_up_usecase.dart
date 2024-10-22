import '../../data/models/user_model.dart';
import '../../data/repositories/email_sign_up_repository.dart';

class SignUpUseCase {
  final UserSignUpRepository repository;

  SignUpUseCase(this.repository);

  Future<ApiResponse> execute(String email, String password) async {
    final user = User(email: email, password: password);
    return await repository.signUp(user);
  }
}
