import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/auth_screens/user_profile_check_response.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_history_api.dart';

class UserProfileApiService {
  Future<UserProfileCheckResponse> checkUserProfile(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.checkUser),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
      
      if (response.statusCode == 200) {
        return UserProfileCheckResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        // Create a response for user not found case
        return UserProfileCheckResponse(
          status: false,
          data: ProfileCheckData(message: 'User not found')
        );
      } else {
        // Other server errors
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Error checking user profile: $e');
    }
  }
}