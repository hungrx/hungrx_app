import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_request.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_responce.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/common_consume_food_repository.dart';

class CommonFoodUseCase {
  final ConsumeCommonFoodRepository _repository;

  CommonFoodUseCase(this._repository);

  Future<CommonFoodResponse> execute(CommonFoodRequest request) async {
    try {
      return await _repository.addCommonFood(request);
    } catch (e) {
      print(e);
      throw Exception('UseCase error: $e');
    }
  }
}