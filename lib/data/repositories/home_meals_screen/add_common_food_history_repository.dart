import 'package:hungrx_app/data/Models/home_meals_screen/common_food/add_common_food_history_request.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/add_common_food_history_api.dart';

class AddCommonFoodHistoryRepository {
  final AddCommonFoodHistoryApi _api;

  AddCommonFoodHistoryRepository(this._api);

  Future<AddCommonFoodHistoryResponse> addToHistory(AddCommonFoodHistoryRequest request) {
    return _api.addToHistory(request);
  }
}