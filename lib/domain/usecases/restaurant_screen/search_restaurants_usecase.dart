import 'package:hungrx_app/data/Models/restuarent_screen/search_restaurant_model.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/search_restaurant_repository.dart';

class SearchRestaurantsUseCase {
  final SearchRestaurantRepository _repository;

  SearchRestaurantsUseCase({SearchRestaurantRepository? repository})
      : _repository = repository ?? SearchRestaurantRepository();

 Future<List<SearchRestaurantModel>> execute(String query) async {
    try {
      return await _repository.searchRestaurants(query);
    } catch (e) {
       throw Exception('Failed to search restaurants: $e');
    }
  }
}