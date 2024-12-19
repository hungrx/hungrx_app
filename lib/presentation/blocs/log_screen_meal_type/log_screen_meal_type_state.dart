import 'package:hungrx_app/data/Models/home_meals_screen/meal_type.dart';

abstract class MealTypeState {}

class MealTypeInitial extends MealTypeState {}
class MealTypeLoading extends MealTypeState {}
class MealTypeLoaded extends MealTypeState {
  final List<MealType> mealTypes;
  final String? selectedMealId;
  MealTypeLoaded({required this.mealTypes, this.selectedMealId});
}
class MealTypeError extends MealTypeState {
  final String message;
  MealTypeError({required this.message});
} 