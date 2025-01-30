import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_request.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_responce.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/common_consume_food_api.dart';

class ConsumeCommonFoodRepository {
  final CommonFoodApi _api;

  ConsumeCommonFoodRepository(this._api);

  Future<CommonFoodResponse> addCommonFood(CommonFoodRequest request) async {
    try {
      return await _api.addCommonFood(request);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
