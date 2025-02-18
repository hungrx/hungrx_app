class ChangeCalorieGoalModel {
  final String userId;
  final double caloriesToReachGoal;
  final int daysToReachGoal;
  final bool status;
  final bool isShown; // Added isShown field

  ChangeCalorieGoalModel({
    required this.userId,
    required this.caloriesToReachGoal,
    required this.daysToReachGoal,
    required this.status,
    required this.isShown, // Added to constructor
  });

  factory ChangeCalorieGoalModel.fromJson(Map<String, dynamic> json) {
    return ChangeCalorieGoalModel(
      userId: json['data']['userId'],
      caloriesToReachGoal:
          double.parse(json['data']['caloriesToReachGoal'].toString()),
      daysToReachGoal: int.parse(
          json['data']['daysToReachGoal'].toString()), // Parse string to int
      status: json['status'],
      isShown: json['data']['isShown'] ?? false, // Added with fallback value
    );
  }
}
