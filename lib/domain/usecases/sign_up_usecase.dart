import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class SignUpUseCase {
  final UserRepository repository;

  SignUpUseCase(this.repository);

  Future<ApiResponse> execute(String email, String password) async {
    final user = User(email: email, password: password);
    return await repository.signUp(user);
  }
}