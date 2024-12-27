import 'package:hungrx_app/data/Models/restuarent_screen/search_restaurant_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/search_restaurant_api.dart';

class SearchRestaurantRepository {
  final SearchRestaurantApi _api;

  SearchRestaurantRepository({SearchRestaurantApi? api}) 
      : _api = api ?? SearchRestaurantApi();

  Future<List<SearchRestaurantModel>> searchRestaurants(String query) async {
    try {
      final response = await _api.searchRestaurants(query);
      
      // Check if status is false and handle the "not found" case
      if (response['status'] == false) {
        // Instead of throwing an exception, return an empty list
        // This will trigger the empty state in the UI
        return [];
      }
      
      if (response['status'] == true && response['data'] != null) {
        return [SearchRestaurantModel.fromJson(response['data'])];
      }
      
      return []; // Return empty list for any other case
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }
}