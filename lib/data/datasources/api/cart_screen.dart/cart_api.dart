import 'dart:convert';
import 'package:http/http.dart' as http;

class CartApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> getCart(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/getCart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}