class UpdateBasicInfoRequest {
  final String userId;
  final String name;
  final String? email;
  final String gender;
  final String mobile;
  final String age;
  final String? heightInCm;
  final String? heightInFeet;
  final String? heightInInches;
  final String? weightInKg;
  final String? weightInLbs;
  final String? targetWeight;
  final bool isMetric;

  UpdateBasicInfoRequest({
    required this.userId,
    required this.name,
    this.email,
    required this.gender,
    required this.mobile,
    required this.age,
    this.heightInCm,
    this.heightInFeet,
    this.heightInInches,
    this.weightInKg,
    this.weightInLbs,
    this.targetWeight,
    required this.isMetric,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'gender': gender,
        'mobile': mobile,
        'age': age,
        'heightInCm': heightInCm,
        'heightInFeet': heightInFeet,
        'heightInInches': heightInInches,
        'weightInKg': weightInKg,
        'weightInLbs': weightInLbs,
        'targetWeight': targetWeight,
        'isMetric': isMetric,
      };
}

class UpdateBasicInfoResponse {
  final bool status;
  final String message;
  final UpdateBasicInfoData data;

  UpdateBasicInfoResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateBasicInfoResponse.fromJson(Map<String, dynamic> json) {
    return UpdateBasicInfoResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: UpdateBasicInfoData.fromJson(
          json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class UpdateBasicInfoData {
  final String name;
  final String? email; // Made nullable
  final String gender;
  final String mobile;
  final String age;
  final String height;
  final String weight;
  final String targetWeight;
  final String goal;
  final bool isMetric;
  final String? bmi; // Added optional fields
  final String? bmr;
  final String? tdee;
  final String? dailyCalorieGoal;
  final String? caloriesToReachGoal;
  final int? daysToReachGoal;
  final String? dailyWaterIntake;

  UpdateBasicInfoData({
    required this.name,
    this.email, // Made optional
    required this.gender,
    required this.mobile,
    required this.age,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.goal,
    required this.isMetric,
    this.bmi,
    this.bmr,
    this.tdee,
    this.dailyCalorieGoal,
    this.caloriesToReachGoal,
    this.daysToReachGoal,
    this.dailyWaterIntake,
  });

  factory UpdateBasicInfoData.fromJson(Map<String, dynamic> json) {
    return UpdateBasicInfoData(
      name: json['name'] as String? ?? '',
      email: json['email'] as String?, // Handle null email
      gender: json['gender'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      age: json['age'] as String? ?? '',
      height: json['height'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      targetWeight: json['targetWeight'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      isMetric: json['isMetric'] as bool? ?? true,
      bmi: json['BMI'] as String?,
      bmr: json['BMR'] as String?,
      tdee: json['TDEE'] as String?,
      dailyCalorieGoal: json['dailyCalorieGoal'] as String?,
      caloriesToReachGoal: json['caloriesToReachGoal'] as String?,
      daysToReachGoal: json['daysToReachGoal'] as int?, 
      dailyWaterIntake: json['dailyWaterIntake'] as String?,
    );
  }
}
