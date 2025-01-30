import 'package:hungrx_app/data/Models/home_meals_screen/common_food/add_common_food_history_request.dart';

abstract class AddCommonFoodHistoryState {}

class AddCommonFoodHistoryInitial extends AddCommonFoodHistoryState {}

class AddCommonFoodHistoryLoading extends AddCommonFoodHistoryState {}

class AddCommonFoodHistorySuccess extends AddCommonFoodHistoryState {
  final AddCommonFoodHistoryResponse response;

  AddCommonFoodHistorySuccess(this.response);
}

class AddCommonFoodHistoryFailure extends AddCommonFoodHistoryState {
  final String error;

  AddCommonFoodHistoryFailure(this.error);
}