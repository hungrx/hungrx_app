import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class CalorieMetricsApi {
  Future<Map<String, dynamic>> getCalorieMetrics(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getCalorieMetrics),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data; // Return the complete response
      }
      throw Exception('Failed to fetch calorie metrics: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching calorie metrics: $e');
    }
  }
}
