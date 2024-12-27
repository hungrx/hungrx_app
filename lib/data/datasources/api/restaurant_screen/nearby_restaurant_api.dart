import 'dart:convert';
import 'package:http/http.dart' as http;

class NearbyRestaurantApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radius = 20000,
    String category = 'all',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/users/nearby?latitude=$latitude&longitude=$longitude&radius=$radius&category=$category',
        ),
      );
// print(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load nearby restaurants');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}