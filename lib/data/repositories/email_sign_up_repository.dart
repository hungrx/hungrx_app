import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/email_model.dart';


class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ApiResponse({required this.success, required this.message, this.data});
}

class UserSignUpRepository {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<ApiResponse> signUp(User user) async {
    try {
      // print("Attempting to sign up user: ${user.email}");
      final response = await http.post(
        Uri.parse('$baseUrl/users/signup/email'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': user.email,
          'password': user.password,
          'reenterPassword': user.password,
        }),
      );

      // print("Response status code: ${response.statusCode}");
      // print("Response body: ${response.body}");

      // Parse the response body
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: responseBody['message'] ?? 'Sign up successful',
          data: responseBody['data'],
        );
      } else if (response.statusCode == 400) {
        // Bad request - likely validation errors
        return ApiResponse(
          success: false,
          message: responseBody['message'] ?? 'Validation error',
          data: responseBody['errors'],
        );
      } else if (response.statusCode == 409) {
        // Conflict - likely email already exists
        return ApiResponse(
          success: false,
          message: responseBody['message'] ?? 'Email already exists',
        );
      } else {
        // Other errors
        return ApiResponse(
          success: false,
          message: responseBody['message'] ?? 'An unexpected error occurred',
        );
      }
    } catch (e) {
      // print("Exception occurred during sign up: $e");
      return ApiResponse(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }
}
