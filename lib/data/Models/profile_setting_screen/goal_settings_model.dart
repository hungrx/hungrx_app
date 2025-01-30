class GoalSettingsModel {
  final String goal;
  final String targetWeight;
  final double weightGainRate;
  final String activityLevel;
  final int mealsPerDay;
  final bool isMetric;       // Added new field
  final double currentWeight;   // Added new field

  GoalSettingsModel({
    required this.goal,
    required this.targetWeight,
    required this.weightGainRate,
    required this.activityLevel,
    required this.mealsPerDay,
    required this.isMetric,
    required this.currentWeight,
  });

  factory GoalSettingsModel.fromJson(Map<String, dynamic> json) {
    return GoalSettingsModel(
      goal: json['goal'] as String,
      targetWeight: json['targetWeight'] as String,
      weightGainRate: json['weightGainRate'].toDouble(),
      activityLevel: json['activityLevel'] as String,
      mealsPerDay: json['mealsPerDay'] as int,
      isMetric: json['isMetric'] as bool,
      currentWeight: json['currentWeight'].toDouble(),
    );
  }
}