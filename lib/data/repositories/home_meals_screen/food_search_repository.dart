import 'package:hungrx_app/data/Models/home_meals_screen/food_item_model.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/food_search_api.dart';

class FoodSearchRepository {
  final FoodSearchApi _api;

  FoodSearchRepository(this._api);

  Future<List<FoodItemModel>> searchFood(String query) => _api.searchFood(query);
}