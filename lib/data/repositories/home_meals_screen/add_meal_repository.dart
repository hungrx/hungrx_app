import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/add_meal_api.dart';

class AddMealRepository {
  final AddMealApi _api;

  AddMealRepository({AddMealApi? api}) : _api = api ?? AddMealApi();

  Future<AddMealResponse> addMealToUser(AddMealRequest request) async {
    try {
      return await _api.addMealToUser(request);
    } catch (e) {
      // print(e);
      // print("hello");
      throw Exception('Repository error: $e');
    }
  }
}