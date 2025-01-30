import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_request.dart';

abstract class CommonFoodEvent {}

class CommonFoodSubmitted extends CommonFoodEvent {
  final CommonFoodRequest request;

  CommonFoodSubmitted(this.request);
}