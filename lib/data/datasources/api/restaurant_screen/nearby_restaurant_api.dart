import 'dart:convert';
import 'package:http/http.dart' as http;

class NearbyRestaurantApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radius = 20000, // Changed default to 1000
    String category = 'all',
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/users/nearby').replace(
        queryParameters: {
          'longitude': "76.205329",
          'latitude': "10.523626",
          'radius': radius.toString(),
          'category': category,
        },
      );

      final response = await http.get(uri);

      // For debugging
      print('Request URL: ${uri.toString()}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load nearby restaurants: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
