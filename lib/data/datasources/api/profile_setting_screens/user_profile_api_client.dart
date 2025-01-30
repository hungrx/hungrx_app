import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/auth_screens/user_profile_model.dart';

class UserProfileApiClient {
  Future<void> addUserProfile(UserInfoProfileModel userProfile) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.createProfile);
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userProfile.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add user profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add user profile: $e');
    }
  }
}
