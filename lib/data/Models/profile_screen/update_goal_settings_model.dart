// ignore_for_file: non_constant_identifier_names

class UpdateGoalSettingsModel {
  final String? userId;
  final String goal;
  final String targetWeight;
  final double weightGainRate;
  final String activityLevel;
  final int mealsPerDay;
  final String BMI;
  final String BMR;
  final String TDEE;
  final String dailyCalorieGoal;
  final String caloriesToReachGoal;
  final int daysToReachGoal;
  final String dailyWaterIntake;

  UpdateGoalSettingsModel({
    this.userId,
    required this.goal,
    required this.targetWeight,
    required this.weightGainRate,
    required this.activityLevel,
    required this.mealsPerDay,
    this.BMI = '',
    this.BMR = '',
    this.TDEE = '',
    this.dailyCalorieGoal = '',
    this.caloriesToReachGoal = '',
    this.daysToReachGoal = 0,
    this.dailyWaterIntake = '',
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
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
      goal: json['goal'] ?? '',
      targetWeight: json['targetWeight']?.toString() ?? '',
      weightGainRate: (json['weightGainRate'] is int)
          ? (json['weightGainRate'] as int).toDouble()
          : (json['weightGainRate'] ?? 0.0),
      activityLevel: json['activityLevel'] ?? '',
      mealsPerDay: json['mealsPerDay'] is String
          ? int.parse(json['mealsPerDay'])
          : json['mealsPerDay'] ?? 0,
      BMI: json['BMI']?.toString() ?? '',
      BMR: json['BMR']?.toString() ?? '',
      TDEE: json['TDEE']?.toString() ?? '',
      dailyCalorieGoal: json['dailyCalorieGoal']?.toString() ?? '',
      caloriesToReachGoal: json['caloriesToReachGoal']?.toString() ?? '',
      daysToReachGoal: json['daysToReachGoal'] is String
          ? int.parse(json['daysToReachGoal'])
          : json['daysToReachGoal'] ?? 0,
      dailyWaterIntake: json['dailyWaterIntake']?.toString() ?? '',
    );
  }
}
