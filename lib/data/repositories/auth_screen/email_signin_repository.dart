import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/auth_screens/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserSignInRepository {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<String> login(LoginModel loginModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login/email'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginModel.toJson()),
      );


print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);


        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data') &&
            responseData['data'] is Map<String, dynamic> &&
            responseData['data'].containsKey('userId')) {
          final userId = responseData['data']['userId'] as String;
          // print('Extracted userId: $userId');
          await _saveUserId(userId);
          return userId;
        } else {
          throw Exception(
              'Invalid response format: userId not found in expected location');
        }
      } else {
        throw Exception(
            'Failed to login: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
}