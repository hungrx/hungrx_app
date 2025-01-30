class HomeData {
  final String username;
  final String goalHeading;
  final bool goalStatus;        // Added field
  final String weight;
  final double caloriesToReachGoal;
  final double dailyCalorieGoal;
  final int daysToReachGoal;
  final double remaining;
  final int consumed;
  final String calculationDate;  // Added field

  HomeData({
    required this.username,
    required this.goalHeading,
    required this.goalStatus,
    required this.weight,
    required this.caloriesToReachGoal,
    required this.dailyCalorieGoal,
    required this.daysToReachGoal,
    required this.remaining,
    required this.consumed,
    required this.calculationDate,
  });

 factory HomeData.fromJson(Map<String, dynamic> json) {
    // Remove the nested data access since it's already handled in the API service
    return HomeData(
      username: json['username']?.toString().trim() ?? '',
      goalHeading: json['goalHeading']?.toString() ?? '',
      goalStatus: json['goalstatus'] as bool? ?? false,
      weight: json['weight']?.toString() ?? '',
      caloriesToReachGoal: _parseDouble(json['caloriesToReachGoal']),
      dailyCalorieGoal: _parseDouble(json['dailyCalorieGoal']),
      daysToReachGoal: _parseInt(json['daysToReachGoal']),
      remaining: _parseDouble(json['remaining']),
      consumed: _parseInt(json['consumed']),
      calculationDate: json['calculationDate']?.toString() ?? '',
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
      'data': {
        'username': username,
        'goalHeading': goalHeading,
        'goalstatus': goalStatus,
        'weight': weight,
        'caloriesToReachGoal': caloriesToReachGoal,
        'dailyCalorieGoal': dailyCalorieGoal,
        'daysToReachGoal': daysToReachGoal,
        'remaining': remaining,
        'consumed': consumed,
        'calculationDate': calculationDate,
      }
    };
  }

  HomeData copyWith({
    String? username,
    String? goalHeading,
    bool? goalStatus,
    String? weight,
    double? caloriesToReachGoal,
    double? dailyCalorieGoal,
    int? daysToReachGoal,
    double? remaining,
    int? consumed,
    String? calculationDate,
  }) {
    return HomeData(
      username: username ?? this.username,
      goalHeading: goalHeading ?? this.goalHeading,
      goalStatus: goalStatus ?? this.goalStatus,
      weight: weight ?? this.weight,
      caloriesToReachGoal: caloriesToReachGoal ?? this.caloriesToReachGoal,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      daysToReachGoal: daysToReachGoal ?? this.daysToReachGoal,
      remaining: remaining ?? this.remaining,
      consumed: consumed ?? this.consumed,
      calculationDate: calculationDate ?? this.calculationDate,
    );
  }
}