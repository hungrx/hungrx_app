import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';

abstract class CommonFoodSearchState {}

class CommonFoodSearchInitial extends CommonFoodSearchState {}

class CommonFoodSearchLoading extends CommonFoodSearchState {}

class CommonFoodSearchSuccess extends CommonFoodSearchState {
  final List<CommonFoodModel> foods;
  CommonFoodSearchSuccess(this.foods);
}

class CommonFoodSearchError extends CommonFoodSearchState {
  final String message;
  CommonFoodSearchError(this.message);
}