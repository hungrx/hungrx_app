import 'dart:convert';
import 'package:http/http.dart' as http;

class NearbyRestaurantApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    
    
    double radius=5000,
    String category = 'all',
  }) async {
    print('API Request - Latitude: $latitude, Longitude: $longitude');
    try {
      final Uri uri = Uri.parse('$baseUrl/users/nearby').replace(
        queryParameters: {
          'longitude': longitude.toString(),
          'latitude': latitude.toString(),
          'radius': radius.toString(),
          'category': category,
        },
      );

      print('Making request to: ${uri.toString()}');
      final response = await http.get(uri);

      print('Response status: ${response.statusCode}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        // Explicitly decode and verify the response structure
        final Map<String, dynamic> decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        
        // Verify that data is a List
        if (decodedResponse['data'] is! List) {
          throw Exception('Expected data to be a List but got ${decodedResponse['data'].runtimeType}');
        }

        return decodedResponse;
      } else {
        throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in API call: $e');
      rethrow; // Rethrow to preserve the original error
    }
  }
}