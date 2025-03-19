class WaterIntakeData {
  final String dailyWaterIntake;
  final DateStats dateStats;

  WaterIntakeData({
    required this.dailyWaterIntake,
    required this.dateStats,
  });

  factory WaterIntakeData.fromJson(Map<String, dynamic> json) {
    return WaterIntakeData(
      dailyWaterIntake: json['dailyWaterIntake'] as String,
      dateStats: DateStats.fromJson(json['dateStats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'dailyWaterIntake': dailyWaterIntake,
    'dateStats': dateStats.toJson(),
  };

  bool equals(WaterIntakeData other) {
    return dailyWaterIntake == other.dailyWaterIntake &&
           dateStats.totalIntake == other.dateStats.totalIntake &&
           dateStats.remaining == other.dateStats.remaining &&
           dateStats.entries.length == other.dateStats.entries.length;
  }
}

class DateStats {
  final String date;
  final int totalIntake;
  final int remaining;
  final List<WaterIntakeEntry> entries;

  DateStats({
    required this.date,
    required this.totalIntake,
    required this.remaining,
    required this.entries,
  });

  factory DateStats.fromJson(Map<String, dynamic> json) {
    return DateStats(
      date: json['date'] as String,
      totalIntake: json['totalIntake'] as int,
      remaining: json['remaining'] as int,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => WaterIntakeEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'totalIntake': totalIntake,
    'remaining': remaining,
    'entries': entries.map((e) => e.toJson()).toList(),
  };
}

class WaterIntakeEntry {
  final int amount;
  final DateTime timestamp;
  final String id;

  WaterIntakeEntry({
    required this.amount,
    required this.timestamp,
    required this.id,
  });

  factory WaterIntakeEntry.fromJson(Map<String, dynamic> json) {
    return WaterIntakeEntry(
      amount: json['amount'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    '_id': id,
  };
}