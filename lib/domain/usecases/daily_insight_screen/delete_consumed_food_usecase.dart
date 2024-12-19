import 'package:hungrx_app/data/Models/daily_insight_screen/delete_consumed_food_request.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/delete_consumed_food_repository.dart';

class DeleteConsumedFoodUseCase {
  final DeleteFoodRepository _repository;

  DeleteConsumedFoodUseCase(this._repository);

  Future<DeleteFoodResponse> execute(DeleteFoodRequest request) {
    return _repository.deleteConsumedFood(request);
  }
}