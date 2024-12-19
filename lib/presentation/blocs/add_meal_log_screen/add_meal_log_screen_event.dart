import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';

abstract class AddMealEvent {}

class AddMealSubmitted extends AddMealEvent {
  final AddMealRequest request;

  AddMealSubmitted(this.request);
}