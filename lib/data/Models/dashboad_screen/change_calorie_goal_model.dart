class ChangeCalorieGoalModel {
  final String userId;
  final double caloriesToReachGoal;
  final int daysToReachGoal;  // Added new field
  final bool status;

  ChangeCalorieGoalModel({
    required this.userId,
    required this.caloriesToReachGoal,
    required this.daysToReachGoal,  // Added to constructor
    required this.status,
  });

  factory ChangeCalorieGoalModel.fromJson(Map<String, dynamic> json) {
    return ChangeCalorieGoalModel(
      userId: json['data']['userId'],
      caloriesToReachGoal: double.parse(json['data']['caloriesToReachGoal'].toString()),
      daysToReachGoal: json['data']['daysToReachGoal'],  // Parse new field
      status: json['status'],
    );
  }
}