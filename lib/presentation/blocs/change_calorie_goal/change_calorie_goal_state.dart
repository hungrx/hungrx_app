import 'package:hungrx_app/data/Models/dashboad_screen/change_calorie_goal_model.dart';

abstract class ChangeCalorieGoalState {}

class ChangeCalorieGoalInitial extends ChangeCalorieGoalState {}

class ChangeCalorieGoalLoading extends ChangeCalorieGoalState {}

class ChangeCalorieGoalSuccess extends ChangeCalorieGoalState {
  final ChangeCalorieGoalModel data;

  ChangeCalorieGoalSuccess(this.data);
}

class ChangeCalorieGoalFailure extends ChangeCalorieGoalState {
  final String error;

  ChangeCalorieGoalFailure(this.error);
}