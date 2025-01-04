import 'package:hungrx_app/data/repositories/profile_setting_screen/user_profile_repository.dart';

class CheckUserProfileUseCase {
  final UserProfileRepository _repository;

  CheckUserProfileUseCase(this._repository);

  Future<bool> execute(String userId) async {
    try {
      return await _repository.checkUserProfileCompletion(userId);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}
