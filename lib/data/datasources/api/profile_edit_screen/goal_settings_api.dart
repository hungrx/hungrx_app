import 'dart:convert';
import 'package:http/http.dart' as http;

class GoalSettingsApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> fetchGoalSettings(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/goalSetting'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data['data'];
        }
        throw Exception('Failed to fetch goal settings: ${data['message']}');
      }
      throw Exception('Failed to fetch goal settings');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}