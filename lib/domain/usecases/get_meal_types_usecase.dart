import 'package:hungrx_app/data/Models/meal_type.dart';
import 'package:hungrx_app/data/repositories/meal_type_repository.dart';

class GetMealTypesUseCase {
  final MealTypeRepository repository;

  GetMealTypesUseCase({required this.repository});

  Future<List<MealType>> execute() async {
    return await repository.getMealTypes();
  }
}
