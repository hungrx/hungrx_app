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

  GetProfileDetailsModel({
    required this.tdee,
    required this.weight,
    required this.isMetric,
    required this.targetWeight,
    required this.bmi,
    required this.name,
    this.profilephoto,
  });

  factory GetProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetProfileDetailsModel(
      tdee: json['TDEE'] ?? '0',
      weight: json['Weight'] ?? 0,
      isMetric: json['isMetric'] ?? true,
      targetWeight: json['targetWeight'] ?? '0',
      bmi: json['BMI'] ?? '0',
      name: json['name'] ?? '',
      profilephoto: json['profilephoto'],
    );
  }
}