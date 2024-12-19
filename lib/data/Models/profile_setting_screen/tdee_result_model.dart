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
    // Helper function to format values
    String formatValue(dynamic value, {String suffix = ''}) {
      if (value == null || value.toString() == 'NaN') {
        return 'Not calculated';
      }
      return '$value$suffix';
    }

    return TDEEResultModel(
      height: formatValue(json['height']),
      weight: formatValue(json['weight']),
      bmi: formatValue(json['BMI']),
      bmr: formatValue(json['BMR'], suffix: ' kcal'),
      tdee: formatValue(json['TDEE'], suffix: ' kcal'),
      dailyCaloriesGoal: formatValue(json['dailyCalorieGoal'], suffix: ' kcal'),
      caloriesToReachGoal: formatValue(json['caloriesToReachGoal'], suffix: ' kcal'),
      daysToReachGoal: formatValue(json['daysToReachGoal'], suffix: ' days'),
      goalPace: formatValue(json['goalPace']),
    );
  }

  // Method to check if model has valid data
  bool isValid() {
    return ![
      height, weight, bmi, bmr, tdee,
      dailyCaloriesGoal, caloriesToReachGoal,
      daysToReachGoal, goalPace
    ].every((value) => value == 'Not calculated');
  }

  // For debugging
  @override
  String toString() {
    return '''TDEEResultModel(
      height: $height,
      weight: $weight,
      bmi: $bmi,
      bmr: $bmr,
      tdee: $tdee,
      dailyCaloriesGoal: $dailyCaloriesGoal,
      caloriesToReachGoal: $caloriesToReachGoal,
      daysToReachGoal: $daysToReachGoal,
      goalPace: $goalPace
    )''';
  }
}