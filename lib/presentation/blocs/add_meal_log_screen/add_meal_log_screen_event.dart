import 'package:hungrx_app/data/Models/add_meal_request.dart';

abstract class AddMealEvent {}

class AddMealSubmitted extends AddMealEvent {
  final AddMealRequest request;

  AddMealSubmitted(this.request);
}