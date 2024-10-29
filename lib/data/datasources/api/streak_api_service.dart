import 'package:http/http.dart' as http;
import 'dart:convert';

class StreakApiService {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<Map<String, dynamic>> fetchUserStreak(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/trackuser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch streak data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}