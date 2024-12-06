class HomeData {
  final String username;
  final String goalHeading;
  final String weight;
  final int caloriesToReachGoal;
  final int dailyCalorieGoal;
  final int daysToReachGoal;
  final int remaining;
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

  // Add copyWith method
  // HomeData copyWith({
  //   String? username,
  //   String? goalHeading,
  //   String? weight,
  //   int? caloriesToReachGoal,
  //   int? dailyCalorieGoal,
  //   int? daysToReachGoal,
  //   int? remaining,
  //   int? consumed,
  // }) {
  //   return HomeData(
  //     username: username ?? this.username,
  //     goalHeading: goalHeading ?? this.goalHeading,
  //     weight: weight ?? this.weight,
  //     caloriesToReachGoal: caloriesToReachGoal ?? this.caloriesToReachGoal,
  //     dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
  //     daysToReachGoal: daysToReachGoal ?? this.daysToReachGoal,
  //     remaining: remaining ?? this.remaining,
  //     consumed: consumed ?? this.consumed,
  //   );
  // }

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
  }}
