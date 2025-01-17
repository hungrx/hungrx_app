import 'dart:convert';
import 'package:http/http.dart' as http;

class ProgressBarApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> fetchProgressBarData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/progressBar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return responseData['data'];
        } else {
          throw Exception('API returned false status');
        }
      } else {
        throw Exception('Failed to fetch progress bar data');
      }
    } catch (e) {
      throw Exception('Error fetching progress bar data: $e');
    }
  }
}