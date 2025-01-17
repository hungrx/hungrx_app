class ProfileResponse {
  final bool status;
  final GetProfileDetailsModel data;

  ProfileResponse({
    required this.status,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      data: GetProfileDetailsModel.fromJson(json['data'] ?? {}),
    );
  }
}

class GetProfileDetailsModel {
  final String tdee;
  final int weight;
  final bool isMetric;
  final String targetWeight;
  final String bmi;
  final String name;
  final String? profilephoto;
  final String gender;           // Added field
  final String dailyCalorieGoal; // Added field
  final int todayConsumption;    // Added field

  GetProfileDetailsModel({
    required this.tdee,
    required this.weight,
    required this.isMetric,
    required this.targetWeight,
    required this.bmi,
    required this.name,
    this.profilephoto,
    required this.gender,           // Added to constructor
    required this.dailyCalorieGoal, // Added to constructor
    required this.todayConsumption, // Added to constructor
  });

  factory GetProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetProfileDetailsModel(
      tdee: json['TDEE'] ?? '0',
      weight: json['weight'] ?? 0,
      isMetric: json['isMetric'] ?? true,
      targetWeight: json['targetWeight'] ?? '0',
      bmi: json['BMI'] ?? '0',
      name: json['name'] ?? '',
      profilephoto: json['profilephoto'],
      gender: json['gender'] ?? '',           // Added parsing
      dailyCalorieGoal: json['dailyCalorieGoal'] ?? '0', // Added parsing
      todayConsumption: json['todayConsumption'] ?? 0,   // Added parsing
    );
  }
}