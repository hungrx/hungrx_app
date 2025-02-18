abstract class ChangeCalorieGoalEvent {}

class SubmitChangeCalorieGoal extends ChangeCalorieGoalEvent {
  final double calorie;
  final int day;
  final bool isShown;
  final String date;

  SubmitChangeCalorieGoal({
    required this.calorie,
    required this.day,
    required this.isShown,
    required this.date,
  });
}