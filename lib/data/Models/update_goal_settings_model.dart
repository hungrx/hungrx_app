class UpdateGoalSettingsModel {
  final String userId;
  final String goal;
  final String targetWeight;
  final double weightGainRate;
  final String activityLevel;
  final int mealsPerDay;

  UpdateGoalSettingsModel({
    required this.userId,
    required this.goal,
    required this.targetWeight,
    required this.weightGainRate,
    required this.activityLevel,
    required this.mealsPerDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'goal': goal,
      'targetWeight': targetWeight,
      'weightGainRate': weightGainRate,
      'activityLevel': activityLevel,
      'mealsPerDay': mealsPerDay,
    };
  }

  factory UpdateGoalSettingsModel.fromJson(Map<String, dynamic> json) {
    return UpdateGoalSettingsModel(
      userId: json['userId'],
      goal: json['goal'],
      targetWeight: json['targetWeight'],
      weightGainRate: json['weightGainRate'].toDouble(),
      activityLevel: json['activityLevel'],
      mealsPerDay: json['mealsPerDay'],
    );
  }
}