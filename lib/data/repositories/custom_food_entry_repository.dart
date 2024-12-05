import 'package:hungrx_app/data/Models/custom_food_entry_response.dart';
import 'package:hungrx_app/data/datasources/api/custom_food_entry_api.dart';

class CustomFoodEntryRepository {
  final CustomFoodEntryApi _api;

  CustomFoodEntryRepository(this._api);

  Future<CustomFoodEntryResponse> addCustomFood({
    required String userId,
    required String mealType,
    required String foodName,
    required double calories,
  }) async {
    return await _api.addCustomFood(
      userId: userId,
      mealType: mealType,
      foodName: foodName,
      calories: calories.toString(),
    );
  }
}