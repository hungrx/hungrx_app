import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class ChangeCalorieGoalApi {
  Future<Map<String, dynamic>> changeCalorieGoal({
    required String userId,
    required double calorie,
    required int day,  // Added day parameter
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.changecaloriesToReachGoal),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'calorie': calorie.toString(),
          'day': day.toString(),  // Added day to request body
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to change calorie goal');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
