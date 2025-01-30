class GetProfileDetailsModel {
  final String name;
  final String? email;  // Changed to nullable since API can return null
  final String gender;
  final String mobile;
  final String age;
  final String height;
  final double weight;
  final double targetWeight;
  final String goal;
  final bool isMetric;
  final String bmi;
  final String bmr;
  final String tdee;
  final String dailyCalorieGoal;
  final double caloriesToReachGoal;
  final int daysToReachGoal;
  final double dailyWaterIntake;
  final String? profilephoto;
  final double todayConsumption;

  GetProfileDetailsModel({
    required this.name,
    this.email,  // Made optional
    required this.gender,
    required this.mobile,
    required this.age,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.goal,
    required this.isMetric,
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.dailyCalorieGoal,
    required this.caloriesToReachGoal,
    required this.daysToReachGoal,
    required this.dailyWaterIntake,
    this.profilephoto,
    required this.todayConsumption,
  });

  factory GetProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert any value to string
    String toStr(dynamic value) => value?.toString() ?? '';
    
    // Helper function to safely parse double
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      // Extract numeric value if string contains units
      String numStr = value.toString().split(' ').first;
      return double.tryParse(numStr) ?? 0.0;
    }

    // Helper function to safely parse int
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    // Special parsing for weight and height with units
    String parseWithUnit(dynamic value, String defaultUnit) {
      if (value == null) return '0 $defaultUnit';
      return value.toString();
    }

    return GetProfileDetailsModel(
      name: toStr(json['name']).trim(),  // Added trim() to remove extra spaces
      email: json['email']?.toString(),  // Keep null if it's null
      gender: toStr(json['gender']),
      mobile: toStr(json['mobile']),
      age: toStr(json['age']),
      height: parseWithUnit(json['height'], 'cm'),
      weight: toDouble(json['weight']),
      targetWeight: toDouble(json['targetWeight']),
      goal: toStr(json['goal']),
      isMetric: json['isMetric'] ?? false,
      bmi: toStr(json['BMI']),
      bmr: toStr(json['BMR']),
      tdee: toStr(json['TDEE']),
      dailyCalorieGoal: toStr(json['dailyCalorieGoal']),
      caloriesToReachGoal: toDouble(json['caloriesToReachGoal']),
      daysToReachGoal: toInt(json['daysToReachGoal']),
      dailyWaterIntake: toDouble(json['dailyWaterIntake']),
      profilephoto: json['profilephoto'],
      todayConsumption: toDouble(json['todayConsumption']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'mobile': mobile,
      'age': age,
      'height': height,
      'weight': weight,
      'targetWeight': targetWeight,
      'goal': goal,
      'isMetric': isMetric,
      'BMI': bmi,
      'BMR': bmr,
      'TDEE': tdee,
      'dailyCalorieGoal': dailyCalorieGoal,
      'caloriesToReachGoal': caloriesToReachGoal,
      'daysToReachGoal': daysToReachGoal,
      'dailyWaterIntake': dailyWaterIntake,
      'profilephoto': profilephoto,
      'todayConsumption': todayConsumption,
    };
  }

  bool equals(GetProfileDetailsModel other) {
    return name == other.name &&
        email == other.email &&
        gender == other.gender &&
        mobile == other.mobile &&
        age == other.age &&
        height == other.height &&
        weight == other.weight &&
        targetWeight == other.targetWeight &&
        goal == other.goal &&
        isMetric == other.isMetric &&
        bmi == other.bmi &&
        bmr == other.bmr &&
        tdee == other.tdee &&
        dailyCalorieGoal == other.dailyCalorieGoal &&
        caloriesToReachGoal == other.caloriesToReachGoal &&
        daysToReachGoal == other.daysToReachGoal &&
        dailyWaterIntake == other.dailyWaterIntake &&
        profilephoto == other.profilephoto &&
        todayConsumption == other.todayConsumption;
  }
}