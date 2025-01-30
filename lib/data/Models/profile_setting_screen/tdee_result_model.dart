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
  final String goal;
  final String activityLevel;
  final String dailyWaterIntake;

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
    required this.goal,
    required this.activityLevel,
    required this.dailyWaterIntake,
  });

  factory TDEEResultModel.fromJson(Map<String, dynamic> json) {
    // Helper function to format values
    String formatValue(dynamic value, {String suffix = '', bool isHeight = false}) {
      if (value == null || value.toString() == 'NaN') {
        return 'Not calculated';
      }

      // Special handling for height
      if (isHeight) {
        try {
          double numValue = double.parse(value.toString().replaceAll(' cm', ''));
          return '${numValue.round()}$suffix';
        } catch (e) {
          return '$value$suffix';
        }
      }
      
      // Handle calories (kcal)
      if (suffix == ' kcal') {
        try {
          double numValue = double.parse(value.toString());
          return '${numValue.round()}$suffix';
        } catch (e) {
          return '$value$suffix';
        }
      }

      return '$value$suffix';
    }

    return TDEEResultModel(
      height: formatValue(json['height'], suffix: ' cm', isHeight: true),
      weight: formatValue(json['weight']),
      bmi: formatValue(json['BMI']),
      bmr: formatValue(json['BMR'], suffix: ' kcal'),
      tdee: formatValue(json['TDEE'], suffix: ' kcal'),
      dailyCaloriesGoal: formatValue(json['dailyCalorieGoal'], suffix: ' kcal'),
      caloriesToReachGoal: formatValue(json['caloriesToReachGoal'], suffix: ' kcal'),
      daysToReachGoal: formatValue(json['daysToReachGoal'], suffix: ' days'),
      goalPace: formatValue(json['goalPace']),
      goal: formatValue(json['goal']),
      activityLevel: formatValue(json['activityLevel']),
      dailyWaterIntake: formatValue(json['dailyWaterIntake'])
    );
  }

  bool isValid() {
    return ![
      height, weight, bmi, bmr, tdee,
      dailyCaloriesGoal, caloriesToReachGoal,
      daysToReachGoal, goalPace, goal,
      activityLevel, dailyWaterIntake
    ].every((value) => value == 'Not calculated');
  }

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
      goalPace: $goalPace,
      goal: $goal,
      activityLevel: $activityLevel,
      dailyWaterIntake: $dailyWaterIntake
    )''';
  }
}