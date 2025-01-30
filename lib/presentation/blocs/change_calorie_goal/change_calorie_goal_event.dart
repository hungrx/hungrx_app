abstract class ChangeCalorieGoalEvent {}

class SubmitChangeCalorieGoal extends ChangeCalorieGoalEvent {
  final double calorie;
  final int day;  // Added day parameter

  SubmitChangeCalorieGoal({
    required this.calorie,
    required this.day,  // Added day parameter
  });
}