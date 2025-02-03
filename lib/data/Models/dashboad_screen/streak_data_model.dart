class StreakDataModel {
  final String userId;
  final String startingDate;
  final String expectedEndDate;
  final int totalDays;
  final int currentStreak;
  final int daysLeft;
  final List<String> dates;
  final bool status;
  final String message;

  StreakDataModel({
    required this.userId,
    required this.startingDate,
    required this.expectedEndDate,
    required this.totalDays,
    required this.currentStreak,
    required this.daysLeft,
    required this.dates,
    required this.status,
    required this.message,
  });

  factory StreakDataModel.fromJson(Map<String, dynamic> json) {
    return StreakDataModel(
      userId: json['data']['userId'],
      startingDate: json['data']['startingDate'],
      expectedEndDate: json['data']['expectedEndDate'],
      totalDays: json['data']['totalDays'],
      currentStreak: json['data']['currentStreak'],
      daysLeft: json['data']['daysLeft'],
      dates: List<String>.from(json['data']['dates']),
      status: json['status'],
      message: json['message'],
    );
  }

  // Convert date string from dd/mm/yyyy to DateTime
  DateTime _parseDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length != 3) {
      throw FormatException('Invalid date format: $dateString');
    }
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      throw FormatException('Error parsing date: $dateString - $e');
    }
  }

  // Get startingDate as DateTime
  DateTime get startDate {
    return _parseDate(startingDate);
  }

  // Get expectedEndDate as DateTime
  DateTime get endDate {
    return _parseDate(expectedEndDate);
  }

  Map<DateTime, int> getStreakMap() {
    Map<DateTime, int> streakMap = {};
    for (String date in dates) {
      final parsedDate = _parseDate(date);
      streakMap[parsedDate] = 1;
    }
    return streakMap;
  }

  // Optional: Add a method to format dates if needed
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}