import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/core/utils/api_exception.dart';

class VerifySubscriptionApiClient {
  final http.Client _httpClient;

  VerifySubscriptionApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> verifySubscription(String userId) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('${ApiConstants.baseUrl}/users/verify'),
        // Uri.parse('https://hungrxbackend.onrender.com/users/verify'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentDate': DateTime.now().toUtc().toIso8601String(),
          'userId': userId,
        }),
      );
      print("userId................$userId");
      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Failed to verify subscription',
          statusCode: response.statusCode,
        );
      }
      print("..........${DateTime.now().toUtc().toIso8601String()}");
      print({".............veryfy sub${response.body}"});

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        message: 'Error verifying subscription: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
