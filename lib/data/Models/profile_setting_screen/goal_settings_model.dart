class GoalSettingsModel {
  final String goal;
  final String targetWeight;
  final double weightGainRate;
  final String activityLevel;
  final int mealsPerDay;
  final bool isMetric;
  final double currentWeight;

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
      weightGainRate: (json['weightGainRate'] as num).toDouble(),
      activityLevel: json['activityLevel'] as String,
      mealsPerDay: json['mealsPerDay'] as int,
      isMetric: json['isMetric'] as bool,
      currentWeight: (json['currentWeight'] as num).toDouble(),
    );
  }

  // Add toJson method for caching
  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'targetWeight': targetWeight,
      'weightGainRate': weightGainRate,
      'activityLevel': activityLevel,
      'mealsPerDay': mealsPerDay,
      'isMetric': isMetric,
      'currentWeight': currentWeight,
    };
  }

  // Add comparison method
  bool equals(GoalSettingsModel other) {
    return goal == other.goal &&
        targetWeight == other.targetWeight &&
        weightGainRate == other.weightGainRate &&
        activityLevel == other.activityLevel &&
        mealsPerDay == other.mealsPerDay &&
        isMetric == other.isMetric &&
        currentWeight == other.currentWeight;
  }
}