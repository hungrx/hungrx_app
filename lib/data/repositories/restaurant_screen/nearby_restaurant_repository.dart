import 'package:geolocator/geolocator.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/nearby_restaurant_api.dart';

class NearbyRestaurantRepository {
  final NearbyRestaurantApi _api;

  NearbyRestaurantRepository(this._api);

  Future<List<NearbyRestaurantModel>> getNearbyRestaurants({double radius = 5000}) async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition();
      print('Current position - Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      // Get API response
      final Map<String, dynamic> response = await _api.getNearbyRestaurants(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: radius,
      );

      print('Repository received response: $response');

      // Validate response structure
      if (response['success'] != true) {
        throw Exception('API returned success: false');
      }

      if (response['data'] == null) {
        throw Exception('API response missing data field');
      }

      final List<dynamic> restaurantsData = response['data'] as List<dynamic>;
      print('Number of restaurants received: ${restaurantsData.length}');

      final List<NearbyRestaurantModel> restaurants = restaurantsData
          .map((restaurantJson) {
            try {
              return NearbyRestaurantModel.fromJson(restaurantJson as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing restaurant: $e');
              print('Problematic restaurant data: $restaurantJson');
              rethrow;
            }
          })
          .toList();

      return restaurants;
    } catch (e) {
      print('Repository error: $e');
      throw Exception('Failed to get nearby restaurants: $e');
    }
  }
}