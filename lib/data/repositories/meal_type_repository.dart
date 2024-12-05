import 'package:hungrx_app/data/Models/meal_type.dart';
import 'package:hungrx_app/data/datasources/api/meal_type_api.dart';

class MealTypeRepository {
  final MealTypeApi api;

  MealTypeRepository({required this.api});

  Future<List<MealType>> getMealTypes() async {
    try {
      final response = await api.getMealTypes();
      return response.map((json) => MealType.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}