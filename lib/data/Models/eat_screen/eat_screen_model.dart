class EatScreenModel {
  final bool status;
  final EatScreenData data;

  EatScreenModel({required this.status, required this.data});

  factory EatScreenModel.fromJson(Map<String, dynamic> json) {
    return EatScreenModel(
      status: json['status'],
      data: EatScreenData.fromJson(json['data']),
    );
  }
}

class EatScreenData {
  final String name;
  final String dailyCalorieGoal;
  final String? profilePhoto;

  EatScreenData({
    required this.name,
    required this.dailyCalorieGoal,
    required this.profilePhoto,
  });

  factory EatScreenData.fromJson(Map<String, dynamic> json) {
    return EatScreenData(
      name: json['name'],
      dailyCalorieGoal: json['dailyCalorieGoal'],
      profilePhoto: json['profilePhoto'],
    );
  }
}