import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/models/otp_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpRepository {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<void> sendOtp(OtpSendModel otpSendModel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/sendOTP'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(otpSendModel.toJson()),
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to send OTP');
    }
  }

  Future<String> verifyOtp(OtpVerifyModel otpVerifyModel) async {
    print("reached here");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/verifyOTP'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(otpVerifyModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final userId = responseBody['userId'];
        if (userId != null) {
          await _saveUserId(userId);
          return userId;
        } else {
          throw Exception('User ID not found in response');
        }
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  Future<void> _saveUserId(String userId) async {
    print(userId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
}