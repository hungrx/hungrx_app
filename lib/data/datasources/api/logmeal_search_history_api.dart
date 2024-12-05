import 'dart:convert';
import 'package:http/http.dart' as http;

class LogMealSearchHistoryApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> addToHistory({
    required String userId,
    required String productId,
  }) async {
    // print(productId);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/addHistory'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'productId': productId,
        }),
      );
// print("User history added log :${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add to history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}