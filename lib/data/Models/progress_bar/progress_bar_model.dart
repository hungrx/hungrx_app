class ProgressBarModel {
  final double dailyCalorieGoal;
  final double totalCaloriesConsumed;

  ProgressBarModel({
    required this.dailyCalorieGoal,
    required this.totalCaloriesConsumed,
  });

  factory ProgressBarModel.fromJson(Map<String, dynamic> json) {
    return ProgressBarModel(
      dailyCalorieGoal: double.parse(json['dailyCalorieGoal'].toString()),
      totalCaloriesConsumed: double.parse(json['totalCaloriesConsumed'].toString()),
    );
  }
}