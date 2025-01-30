import 'package:hungrx_app/data/Models/home_meals_screen/common_food/add_common_food_history_request.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/add_common_food_history_repository.dart';

class AddCommonFoodHistoryUseCase {
  final AddCommonFoodHistoryRepository _repository;

  AddCommonFoodHistoryUseCase(this._repository);

  Future<AddCommonFoodHistoryResponse> execute(AddCommonFoodHistoryRequest request) {
    return _repository.addToHistory(request);
  }
}
