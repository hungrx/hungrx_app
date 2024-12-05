import 'package:hungrx_app/data/Models/custom_food_entry_response.dart';

abstract class CustomFoodEntryState {}

class CustomFoodEntryInitial extends CustomFoodEntryState {}

class CustomFoodEntryLoading extends CustomFoodEntryState {}

class CustomFoodEntrySuccess extends CustomFoodEntryState {
  final CustomFoodEntryResponse response;

  CustomFoodEntrySuccess(this.response);
}

class CustomFoodEntryFailure extends CustomFoodEntryState {
  final String error;

  CustomFoodEntryFailure(this.error);
}