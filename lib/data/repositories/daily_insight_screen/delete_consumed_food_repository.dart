import 'package:hungrx_app/data/Models/daily_insight_screen/delete_consumed_food_request.dart';
import 'package:hungrx_app/data/datasources/api/daily_insight_screen/delete_consumed_food_api_service.dart';

class DeleteFoodRepository {
  final DeleteFoodApiService _apiService;

  DeleteFoodRepository(this._apiService);

  Future<DeleteFoodResponse> deleteConsumedFood(DeleteFoodRequest request) {
    return _apiService.deleteConsumedFood(request);
  }
}