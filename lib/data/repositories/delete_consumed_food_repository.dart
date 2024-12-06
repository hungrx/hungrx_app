import 'package:hungrx_app/data/Models/delete_consumed_food_request.dart';
import 'package:hungrx_app/data/datasources/api/delete_consumed_food_api_service.dart';

class DeleteFoodRepository {
  final DeleteFoodApiService _apiService;

  DeleteFoodRepository(this._apiService);

  Future<DeleteFoodResponse> deleteConsumedFood(DeleteFoodRequest request) {
    return _apiService.deleteConsumedFood(request);
  }
}