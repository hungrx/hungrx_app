class GetBasicInfoResponse {
  final bool status;
  final UserBasicInfo data;

  GetBasicInfoResponse({required this.status, required this.data});

  factory GetBasicInfoResponse.fromJson(Map<String, dynamic> json) {
    return GetBasicInfoResponse(
      status: json['status'] ?? false,
      data: UserBasicInfo.fromJson(json['data'] ?? {}),
    );
  }
}

class UserBasicInfo {
  final String name;
  final String email;
  final String gender;
  final String? phone;
  final String age;
  final String? heightInCm;
  final String? heightInFeet;
  final String? heightInInches;
  final String? weightInKg;
  final String? weightInLbs;
  final String targetWeight;
  final String dailyCalorieGoal;
  final String daysToReachGoal;
  final String caloriesToReachGoal;
  final String activityLevel;
  final String goal;
  final int mealsPerDay;
  final String weightGainRate;
  final bool isMetric;
  final bool isVerified;

  UserBasicInfo({
    required this.name,
    required this.email,
    required this.gender,
    this.phone,
    required this.age,
    this.heightInCm,
    this.heightInFeet,
    this.heightInInches,
    this.weightInKg,
    this.weightInLbs,
    required this.targetWeight,
    required this.dailyCalorieGoal,
    required this.daysToReachGoal,
    required this.caloriesToReachGoal,
    required this.activityLevel,
    required this.goal,
    required this.mealsPerDay,
    required this.weightGainRate,
    required this.isMetric,
    required this.isVerified,
  });

  factory UserBasicInfo.fromJson(Map<String, dynamic> json) {
    return UserBasicInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'],
      age: json['age'] ?? '',
      heightInCm: json['heightInCm'],
      heightInFeet: json['heightInFeet'],
      heightInInches: json['heightInInches'],
      weightInKg: json['weightInKg'],
      weightInLbs: json['weightInLbs'],
      targetWeight: json['targetWeight'] ?? '',
      dailyCalorieGoal: json['dailyCalorieGoal'] ?? '',
      daysToReachGoal: json['daysToReachGoal'] ?? '',
      caloriesToReachGoal: json['caloriesToReachGoal'] ?? '',
      activityLevel: json['activityLevel'] ?? '',
      goal: json['goal'] ?? '',
      mealsPerDay: json['mealsPerDay'] ?? 3,
      weightGainRate: json['weightGainRate'] ?? '',
      isMetric: json['isMetric'] ?? true,
      isVerified: json['isVerified'] ?? false,
    );
  }

  // Helper method to get height in feet and inches format
  String? getFormattedHeight() {
    if (isMetric && heightInCm != null) {
      return '$heightInCm cm';
    } else if (!isMetric && heightInFeet != null && heightInInches != null) {
      return '$heightInFeet ft $heightInInches in';
    }
    return null;
  }

  // Helper method to get weight in appropriate unit
  String? getFormattedWeight() {
    if (isMetric && weightInKg != null) {
      return '$weightInKg kg';
    } else if (!isMetric && weightInLbs != null) {
      return '$weightInLbs lbs';
    }
    return null;
  }
}