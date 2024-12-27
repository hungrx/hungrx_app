import 'package:geolocator/geolocator.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/nearby_restaurant_api.dart';

class NearbyRestaurantRepository {
  final NearbyRestaurantApi _api;

  NearbyRestaurantRepository(this._api);

  Future<List<NearbyRestaurantModel>> getNearbyRestaurants() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition();
      
      final response = await _api.getNearbyRestaurants(
        latitude: position.latitude,
        longitude: position.longitude,
      );
// print(response['data']);
      if (response['success'] == true && response['data'] != null) {
        return List<NearbyRestaurantModel>.from(
          response['data'].map((x) => NearbyRestaurantModel.fromJson(x)),
        );
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get nearby restaurants: $e');
    }
  }
}