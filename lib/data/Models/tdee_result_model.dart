class TDEEResultModel {
  final String height;
  final String weight;
  final String bmi;
  final String bmr;
  final String tdee;
  final String dailyCaloriesGoal;
  final String caloriesToReachGoal;
  final String daysToReachGoal;
  final String goalPace;

  TDEEResultModel({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.dailyCaloriesGoal,
    required this.caloriesToReachGoal,
    required this.daysToReachGoal,
    required this.goalPace,
  });

  factory TDEEResultModel.fromJson(Map<String, dynamic> json) {
    return TDEEResultModel(
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      bmi: json['BMI'] ?? '',
      bmr: json['BMR'] ?? '',
      tdee: json['TDEE'] ?? '',
      dailyCaloriesGoal: json['dailyCaloriesGoal'] ?? '',
      caloriesToReachGoal: json['caloriesToReachGaal'] ?? '', // Note: API typo
      daysToReachGoal: json['Days to Reach Goal'] ?? '',
      goalPace: json['goalPace'] ?? '',
    );
  }
}
