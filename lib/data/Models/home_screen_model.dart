class HomeData {
  final String username;
  final String goalHeading;
  final String weight;
  final double caloriesToReachGoal;
  final double dailyCalorieGoal;
  final int daysToReachGoal;
  final String profilePhoto;
  final double remaining;

  HomeData({
    required this.username,
    required this.goalHeading,
    required this.weight,
    required this.caloriesToReachGoal,
    required this.dailyCalorieGoal,
    required this.daysToReachGoal,
    required this.profilePhoto,
    required this.remaining,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      username: json['username'] ?? '',
      goalHeading: json['goalHeading'] ?? '',
      weight: json['weight'] ?? '',
      caloriesToReachGoal: double.parse(json['caloriesToReachGoal'] ?? '0'),
      dailyCalorieGoal: double.parse(json['dailyCalorieGoal'] ?? '0'),
      daysToReachGoal: int.parse(json['daysToReachGoal'].toString()),
      profilePhoto: json['profilePhoto'] ?? '',
      remaining: double.parse(json['remaining'] ?? '0'),
    );
  }
}