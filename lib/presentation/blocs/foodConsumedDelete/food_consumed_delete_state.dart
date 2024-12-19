import 'package:hungrx_app/data/Models/daily_insight_screen/delete_consumed_food_request.dart';

abstract class DeleteFoodState {}

class DeleteFoodInitial extends DeleteFoodState {}

class DeleteFoodLoading extends DeleteFoodState {}

class DeleteFoodSuccess extends DeleteFoodState {
  final DeleteFoodResponse response;

  DeleteFoodSuccess(this.response);
}

class DeleteFoodFailure extends DeleteFoodState {
  final String error;

  DeleteFoodFailure(this.error);
}