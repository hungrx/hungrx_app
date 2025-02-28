import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class NearbyRestaurantApi {
  Future<Map<String, dynamic>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
   required double radius,
    String category = 'all',
  }) async {
    print(radius);
    try {
      final Uri uri =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.nearby).replace(
        queryParameters: {
          'longitude': longitude.toString(),
          'latitude': latitude.toString(),
          'radius': radius.toString(),
          'category': category,
        },
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse =
            json.decode(response.body) as Map<String, dynamic>;

        // Verify that data is a List
        if (decodedResponse['data'] is! List) {
          throw Exception(
              'Expected data to be a List but got ${decodedResponse['data'].runtimeType}');
        }

        return decodedResponse;
      } else {
        throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in API call: $e');
      rethrow; // Rethrow to preserve the original error
    }
  }
}
