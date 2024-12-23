import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/suggested_restaurants_api.dart';

class SuggestedRestaurantsRepository {
  final SuggestedRestaurantsApi _api;

  SuggestedRestaurantsRepository(this._api);

  Future<List<SuggestedRestaurantModel>> getSuggestedRestaurants() async {
    try {
      return await _api.getSuggestedRestaurants();
    } catch (e) {
      rethrow;
    }
  }
}