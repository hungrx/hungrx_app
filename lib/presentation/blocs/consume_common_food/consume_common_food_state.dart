import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_responce.dart';

abstract class CommonFoodState {}

class CommonFoodInitial extends CommonFoodState {}

class CommonFoodLoading extends CommonFoodState {}

class CommonFoodSuccess extends CommonFoodState {
  final CommonFoodResponse response;

  CommonFoodSuccess(this.response);
}

class CommonFoodFailure extends CommonFoodState {
  final String error;

  CommonFoodFailure(this.error);
}