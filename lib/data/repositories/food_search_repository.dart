import 'package:hungrx_app/data/Models/food_item_model.dart';
import 'package:hungrx_app/data/datasources/api/food_search_api.dart';

class FoodSearchRepository {
  final FoodSearchApi _api;

  FoodSearchRepository(this._api);

  Future<List<FoodItemModel>> searchFood(String query) => _api.searchFood(query);
}