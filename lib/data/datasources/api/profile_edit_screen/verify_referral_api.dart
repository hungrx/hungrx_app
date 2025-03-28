import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/profile_screen/verify_referral_model.dart';

class VerifyReferralApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> verifyReferralCode(
      VerifyReferralModel referralData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/verifyRef'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(referralData.toJson()),
      );

      final responseData = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        return {
          'success': responseData['status'],
          'message': responseData['message'],
          'data': responseData['status'] ? responseData : null,
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Failed to verify referral code',
          'data': null,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
        'data': null,
      };
    }
  }
}
