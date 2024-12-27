import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportBugApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> reportBug(String userId, String report) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/bug'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'report': report,
        }),
      );
// print(response.body);
// print(response.statusCode);
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit bug report');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}