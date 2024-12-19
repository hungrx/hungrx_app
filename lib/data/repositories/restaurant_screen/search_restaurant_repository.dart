import 'package:hungrx_app/data/Models/restuarent_screen/search_restaurant_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/search_restaurant_api.dart';

class SearchRestaurantRepository {
  final SearchRestaurantApi _api;

  SearchRestaurantRepository({SearchRestaurantApi? api}) : _api = api ?? SearchRestaurantApi();

  Future<List<SearchRestaurantModel>> searchRestaurants(String query) async {
    try {
      final response = await _api.searchRestaurants(query);
      if (response['status'] == true && response['data'] != null) {
        return [SearchRestaurantModel.fromJson(response['data'])];
      }
      return []; // Return empty list if no results
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }
}