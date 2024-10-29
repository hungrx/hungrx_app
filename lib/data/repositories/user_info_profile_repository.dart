import 'package:hungrx_app/data/Models/user_profile_model.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfileRepository {
  final UserProfileApiClient _apiClient;
  static const String hasProfileKey = 'has_user_profile';

  UserProfileRepository(this._apiClient);

  Future<void> addUserProfile(UserInfoProfileModel userProfile) async {
    await _apiClient.addUserProfile(userProfile);
     // Save profile completion status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hasProfileKey, true);
  }

  Future<bool> hasUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId == null) return false;
      
      // First check local storage for faster response
      final hasProfile = prefs.getBool(hasProfileKey) ?? false;
      if (!hasProfile) return false;

      // Verify with API
      final profileExists = await _apiClient.checkUserProfile(userId);
      return profileExists;
    } catch (e) {
      print('Error checking user profile: $e');
      return false;
    }
  }

  Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(hasProfileKey);
  }
}