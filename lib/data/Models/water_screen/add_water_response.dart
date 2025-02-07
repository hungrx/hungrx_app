class AddWaterResponse {
  final bool success;
  final WaterIntakeData data;

  AddWaterResponse({
    required this.success,
    required this.data,
  });

  factory AddWaterResponse.fromJson(Map<String, dynamic> json) {
    return AddWaterResponse(
      success: json['success'] ?? false,
      data: WaterIntakeData.fromJson(json['data']),
    );
  }
}

class WaterIntakeData {
  final String date;
  final int totalIntake;
  final double remaining;    // Changed from int to double
  final double dailyGoal;    // Changed from int to double
  final List<WaterEntry> entries;
  final String percentage;

  WaterIntakeData({
    required this.date,
    required this.totalIntake,
    required this.remaining,
    required this.dailyGoal,
    required this.entries,
    required this.percentage,
  });

  factory WaterIntakeData.fromJson(Map<String, dynamic> json) {
    return WaterIntakeData(
      date: json['date'] ?? '',
      totalIntake: json['totalIntake']?.toInt() ?? 0,
      remaining: (json['remaining'] ?? 0).toDouble(),
      dailyGoal: (json['dailyGoal'] ?? 0).toDouble(),
      entries: (json['entries'] as List<dynamic>)
          .map((entry) => WaterEntry.fromJson(entry))
          .toList(),
      percentage: json['percentage'] ?? '0',
    );
  }
}

class WaterEntry {
  final int amount;
  final DateTime timestamp;
  final String id;

  WaterEntry({
    required this.amount,
    required this.timestamp,
    required this.id,
  });

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      amount: json['amount'] ?? 0,
      timestamp: DateTime.parse(json['timestamp']),
      id: json['_id'] ?? '',
    );
  }
}