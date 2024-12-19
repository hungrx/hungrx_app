import 'package:hungrx_app/data/Models/home_meals_screen/custom_food_entry_response.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/custom_food_entry_repository.dart';

class CustomFoodEntryUseCase {
  final CustomFoodEntryRepository _repository;

  CustomFoodEntryUseCase(this._repository);

  Future<CustomFoodEntryResponse> execute({
    required String userId,
    required String mealType,
    required String foodName,
    required double calories,
  }) async {
    return await _repository.addCustomFood(
      userId: userId,
      mealType: mealType,
      foodName: foodName,
      calories: calories,
    );
  }
}