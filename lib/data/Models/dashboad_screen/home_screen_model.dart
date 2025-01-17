class HomeData {
  final String username;
  final String goalHeading;
  final String weight;
  final double caloriesToReachGoal;  // Changed to double
  final double dailyCalorieGoal;     // Changed to double
  final int daysToReachGoal;
  final double remaining;            // Changed to double
  final int consumed;

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
      caloriesToReachGoal: _parseDouble(json['caloriesToReachGoal']),
      dailyCalorieGoal: _parseDouble(json['dailyCalorieGoal']),
      daysToReachGoal: _parseInt(json['daysToReachGoal']),
      remaining: _parseDouble(json['remaining']),
      consumed: _parseInt(json['consumed']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

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

  // Here's the copyWith method if you need it
  HomeData copyWith({
    String? username,
    String? goalHeading,
    String? weight,
    double? caloriesToReachGoal,
    double? dailyCalorieGoal,
    int? daysToReachGoal,
    double? remaining,
    int? consumed,
  }) {
    return HomeData(
      username: username ?? this.username,
      goalHeading: goalHeading ?? this.goalHeading,
      weight: weight ?? this.weight,
      caloriesToReachGoal: caloriesToReachGoal ?? this.caloriesToReachGoal,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      daysToReachGoal: daysToReachGoal ?? this.daysToReachGoal,
      remaining: remaining ?? this.remaining,
      consumed: consumed ?? this.consumed,
    );
  }
}