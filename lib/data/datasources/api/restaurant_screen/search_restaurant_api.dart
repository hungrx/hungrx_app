import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchRestaurantApi {
  static const baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> searchRestaurants(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/searchRestaurant'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': query}),
      );
print(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search restaurants');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}