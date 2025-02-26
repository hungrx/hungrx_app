class CalorieMetricsModel {
  final bool status;
  final CalorieMetricsData? data;

  CalorieMetricsModel({
    required this.status,
    required this.data,
  });

  factory CalorieMetricsModel.fromJson(Map<String, dynamic> json) {
    return CalorieMetricsModel(
      status: json['status'] ?? false,
      data: json['data'] != null ? CalorieMetricsData.fromJson(json['data']) : null,
    );
  }
}

class CalorieMetricsData {
  final double consumedCalories;
  final double dailyTargetCalories;
  final double remainingCalories;
  final String weightChangeRate;
  final int daysLeft;
  final String goal;
  final String date;
  final String calorieStatus;
  final String message;
  final double dailyWeightLoss;
  final double ratio;
  final String caloriesToReachGoal;
  final bool isShown;

  CalorieMetricsData({
    required this.consumedCalories,
    required this.dailyTargetCalories,
    required this.remainingCalories,
    required this.weightChangeRate,
    required this.daysLeft,
    required this.goal,
    required this.date,
    required this.calorieStatus,
    required this.message,
    required this.dailyWeightLoss,
    required this.ratio,
    required this.caloriesToReachGoal,
    required this.isShown,
  });

  // Define both helper methods inside the class
  static double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) {
      final double result = value.toDouble();
      if (result.isFinite) return result;
      return 0.0;
    }
    if (value is String) {
      try {
        final double parsed = double.parse(value);
        if (parsed.isFinite) return parsed;
      } catch (_) {}
    }
    return 0.0;
  }

  static int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) {
      if (value.isFinite) return value.toInt();
      return 0;
    }
    if (value is String) {
      try {
        final int parsed = int.parse(value);
        if (parsed.isFinite) return parsed;
      } catch (_) {}
    }
    return 0;
  }

  factory CalorieMetricsData.fromJson(Map<String, dynamic> json) {
    print("Parsing CalorieMetricsData from: $json");
    try {
      return CalorieMetricsData(
        consumedCalories: _safeDouble(json['consumedCalories']),
        dailyTargetCalories: _safeDouble(json['dailyTargetCalories']),
        remainingCalories: _safeDouble(json['remainingCalories']),
        weightChangeRate: json['weightChangeRate']?.toString() ?? '',
        daysLeft: _safeInt(json['daysLeft']),
        goal: json['goal']?.toString() ?? '',
        date: json['date']?.toString() ?? '',
        calorieStatus: json['calorieStatus']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        dailyWeightLoss: _safeDouble(json['dailyWeightLoss']),
        ratio: _safeDouble(json['ratio']),
        caloriesToReachGoal: json['caloriesToReachGoal']?.toString() ?? '',
        isShown: json['isShown'] ?? false,
      );
    } catch (e) {
      print("Error parsing CalorieMetricsData: $e");
      rethrow;
    }
  }
}