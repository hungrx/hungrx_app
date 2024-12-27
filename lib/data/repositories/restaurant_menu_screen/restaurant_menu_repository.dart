import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/restaurant_menu_api.dart';


class RestaurantMenuRepository {
  final RestaurantMenuApi _api;

  RestaurantMenuRepository(this._api);

  Future<RestaurantMenuResponse> getMenu(String restaurantId, String userId) async {
    try {
      return await _api.getMenu(restaurantId, userId);
    } catch (e) {
      rethrow;
    }
  }
}