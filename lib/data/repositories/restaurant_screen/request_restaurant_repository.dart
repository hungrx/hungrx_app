import 'package:hungrx_app/data/Models/restuarent_screen/request_restaurant_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/request_restaurant_api.dart';

class RequestRestaurantRepository {
  final RequestRestaurantApi api;

  RequestRestaurantRepository(this.api);

  Future<bool> requestRestaurant(RequestRestaurantModel request) async {
    try {
      final response = await api.requestRestaurant(request);
      return response['status'] ?? false;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
