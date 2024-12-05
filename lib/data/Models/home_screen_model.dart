class HomeData {
  final String username;
  final String goalHeading;
  final String weight;
  final int caloriesToReachGoal;    // Changed to int since API sends integer
  final int dailyCalorieGoal;       // Changed to int since API sends integer
  final int daysToReachGoal;
  final int remaining;              // Changed to int since API sends integer
  final int consumed;               // Added new field from API response

  HomeData({
    required this.username,
    required this.goalHeading,
    required this.weight,
    required this.caloriesToReachGoal,
    required this.dailyCalorieGoal,
    required this.daysToReachGoal,
    required this.remaining,
    required this.consumed,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      username: json['username']?.toString() ?? '',
      goalHeading: json['goalHeading']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      caloriesToReachGoal: _parseInt(json['caloriesToReachGoal']),
      dailyCalorieGoal: _parseInt(json['dailyCalorieGoal']),
      daysToReachGoal: _parseInt(json['daysToReachGoal']),
      remaining: _parseInt(json['remaining']),
      consumed: _parseInt(json['consumed']),
    );
  }

  // Helper method to parse integers from various data types
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  // Optional: Add a method to convert the object to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'goalHeading': goalHeading,
      'weight': weight,
      'caloriesToReachGoal': caloriesToReachGoal,
      'dailyCalorieGoal': dailyCalorieGoal,
      'daysToReachGoal': daysToReachGoal,
      'remaining': remaining,
      'consumed': consumed,
    };
  }
}