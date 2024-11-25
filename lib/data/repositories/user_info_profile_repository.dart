import 'package:hungrx_app/data/Models/user_profile_model.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_client.dart';



class UserProfileRepository {
  final UserProfileApiClient _apiClient;


  UserProfileRepository(this._apiClient);

  Future<void> addUserProfile(UserInfoProfileModel userProfile) async {
    await _apiClient.addUserProfile(userProfile);
  }
}