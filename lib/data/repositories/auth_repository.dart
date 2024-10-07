import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_model.dart';

class AuthRepository {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<String> login(LoginModel loginModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login/email'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginModel.toJson()),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Decoded response data: $responseData');

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data') &&
            responseData['data'] is Map<String, dynamic> &&
            responseData['data'].containsKey('token')) {
          final token = responseData['data']['token'] as String;
          print('Extracted token: $token');
          await _saveToken(token);
          return token;
        } else {
          throw Exception('Invalid response format: token not found in expected location');
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}