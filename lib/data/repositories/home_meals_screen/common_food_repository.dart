import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/common_food_api.dart';

class CommonFoodRepository {
  final CommonFoodApi _api;

  CommonFoodRepository({CommonFoodApi? api}) : _api = api ?? CommonFoodApi();

  Future<List<CommonFoodModel>> searchCommonFood(String query) {
    return _api.searchCommonFood(query);
  }
}