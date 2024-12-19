class UpdateBasicInfoRequest {
  final String userId;
  final String name;
  final String email;
  final String gender;
  final String mobile;
  final String age;
  final String? heightInCm;
  final String? heightInFeet;
  final String? heightInInches;
  final String? weightInKg;
  final String? weightInLbs;
  final String targetWeight;
  final bool isMetric;

  UpdateBasicInfoRequest({
    required this.userId,
    required this.name,
    required this.email,
    required this.gender,
    required this.mobile,
    required this.age,
    this.heightInCm,
    this.heightInFeet,
    this.heightInInches,
    this.weightInKg,
    this.weightInLbs,
    required this.targetWeight,
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
      status: json['status'],
      message: json['message'],
      data: UpdateBasicInfoData.fromJson(json['data']),
    );
  }
}

class UpdateBasicInfoData {
  final String name;
  final String email;
  final String gender;
  final String mobile;
  final String age;
  final String height;
  final String weight;
  final String targetWeight;
  final String goal;
  final bool isMetric;

  UpdateBasicInfoData({
    required this.name,
    required this.email,
    required this.gender,
    required this.mobile,
    required this.age,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.goal,
    required this.isMetric,
  });

  factory UpdateBasicInfoData.fromJson(Map<String, dynamic> json) {
    return UpdateBasicInfoData(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      mobile: json['mobile'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      targetWeight: json['targetWeight'],
      goal: json['goal'],
      isMetric: json['isMetric'],
    );
  }
}
