class CalorieMetricsModel {
  final double consumedCalories;
  final double dailyTargetCalories;
  final double remainingCalories;
  final String weightChangeRate;
  final int daysLeft;
  final String goal;
  final String date;
  final String calorieStatus;
  final String message;
  final double dailyWeightLoss;
  final double ratio;
  final String caloriesToReachGoal;

  CalorieMetricsModel({
    required this.consumedCalories,
    required this.dailyTargetCalories,
    required this.remainingCalories,
    required this.weightChangeRate,
    required this.daysLeft,
    required this.goal,
    required this.date,
    required this.calorieStatus,
    required this.message,
    required this.dailyWeightLoss,
    required this.ratio,
    required this.caloriesToReachGoal,
  });

  factory CalorieMetricsModel.fromJson(Map<String, dynamic> json) {
    return CalorieMetricsModel(
      consumedCalories: json['consumedCalories'].toDouble(),
      dailyTargetCalories: json['dailyTargetCalories'].toDouble(),
      remainingCalories: json['remainingCalories'].toDouble(),
      weightChangeRate: json['weightChangeRate'],
      daysLeft: json['daysLeft'],
      goal: json['goal'],
      date: json['date'],
      calorieStatus: json['calorieStatus'],
      message: json['message'],
      dailyWeightLoss: json['dailyWeightLoss'].toDouble(),
      ratio: json['ratio'].toDouble(),
      caloriesToReachGoal: json['caloriesToReachGoal'],
    );
  }
}