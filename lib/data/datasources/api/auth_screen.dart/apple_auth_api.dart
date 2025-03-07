import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/auth_screens/apple_auth_response.dart';

class AppleAuthApi {
  final String baseUrl = 'https://hungrx.xyz';

  Future<AppleAuthResponse> loginWithApple({
    required String idToken,
    required String authCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/loginWithApple'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': idToken,
          'code': authCode,
        }),
      );

      if (response.statusCode == 200) {
        return AppleAuthResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to authenticate: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
