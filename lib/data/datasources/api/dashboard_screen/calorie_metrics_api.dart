import 'dart:convert';
import 'package:http/http.dart' as http;

class CalorieMetricsApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> getCalorieMetrics(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/getCalorieMetrics'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data['data'];
        }
        throw Exception('API returned false status');
      }
      throw Exception('Failed to fetch calorie metrics');
    } catch (e) {
      throw Exception('Error fetching calorie metrics: $e');
    }
  }
}