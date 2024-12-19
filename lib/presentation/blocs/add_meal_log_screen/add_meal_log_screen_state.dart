import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';

abstract class AddMealState {}

class AddMealInitial extends AddMealState {}

class AddMealLoading extends AddMealState {}

class AddMealSuccess extends AddMealState {
  final AddMealResponse response;

  AddMealSuccess(this.response);
}

class AddMealFailure extends AddMealState {
  final String error;

  AddMealFailure(this.error);
}
