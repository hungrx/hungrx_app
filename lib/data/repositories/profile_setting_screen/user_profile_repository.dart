import 'package:hungrx_app/data/datasources/api/service_api/user_profile_api_service.dart';

// for check user exist
class UserProfileRepository {
  final UserProfileApiService _apiService;

  UserProfileRepository(this._apiService);

  Future<bool> checkUserProfileCompletion(String userId) async {
    try {
      final response = await _apiService.checkUserProfile(userId);
      return response.status && response.data.message == "User exists";
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}