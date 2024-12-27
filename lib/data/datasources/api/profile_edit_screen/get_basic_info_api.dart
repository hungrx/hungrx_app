import 'dart:convert';
import 'package:http/http.dart' as http;

class GetBasicInfoApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> getBasicInfo(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/basicInfo'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
// print(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load basic info');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}