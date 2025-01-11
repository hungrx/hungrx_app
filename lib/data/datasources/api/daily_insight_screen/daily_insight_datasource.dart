import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/daily_insight_screen/daily_food_response.dart';

class DailyInsightDataSource {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<DailyFoodResponse> getDailyInsightData({
    required String userId,
    required String date,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/getConsumedFoodByDate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'date': date,
        }),
      );
// print(response.body);
      if (response.statusCode == 200) {
        return DailyFoodResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load daily insight data');
      }
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}