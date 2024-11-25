import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/user_profile_check_response.dart';

class UserProfileApiService {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<UserProfileCheckResponse> checkUserProfile(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/checkUser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        return UserProfileCheckResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to check user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking user profile: $e');
    }
  }
}