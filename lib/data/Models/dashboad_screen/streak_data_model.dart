class StreakDataModel {
  final String userId;
  final String startingDate;
  final String? expectedEndDate;
  final int? totalDays;
  final int? currentStreak;
  final int daysLeft;
  final List<String> dates;
  final bool status;
  final String message;

  StreakDataModel({
    required this.userId,
    required this.startingDate,
    this.expectedEndDate,
    this.totalDays,
    this.currentStreak,
    required this.daysLeft,
    required this.dates,
    required this.status,
    required this.message,
  });

  factory StreakDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return StreakDataModel(
      userId: data['userId'] as String,
      startingDate: data['startingDate'] as String,
      expectedEndDate: data['expectedEndDate'] as String?,
      totalDays: data['totalDays'] as int?,
      currentStreak: data['currentStreak'] as int?,
      daysLeft: data['daysLeft'] as int,
      dates: List<String>.from(data['dates'] ?? []),
      status: json['status'] as bool? ?? data['status'] as bool,
      message: json['message'] as String? ?? data['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': {
      'userId': userId,
      'startingDate': startingDate,
      'expectedEndDate': expectedEndDate,
      'totalDays': totalDays,
      'currentStreak': currentStreak,
      'daysLeft': daysLeft,
      'dates': dates,
    },
    'status': status,
    'message': message,
  };

  bool equals(StreakDataModel other) {
    return userId == other.userId &&
           startingDate == other.startingDate &&
           daysLeft == other.daysLeft &&
           dates.length == other.dates.length &&
           dates.every((date) => other.dates.contains(date));
  }

  // Convert date string from dd/mm/yyyy to DateTime
  DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    
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
    return _parseDate(startingDate)!;  // We know startingDate is required
  }

  // Get expectedEndDate as DateTime
  DateTime? get endDate {
    return _parseDate(expectedEndDate);  // Return null if expectedEndDate is null
  }

  Map<DateTime, int> getStreakMap() {
    Map<DateTime, int> streakMap = {};
    for (String date in dates) {
      final parsedDate = _parseDate(date);
      if (parsedDate != null) {
        streakMap[parsedDate] = 1;
      }
    }
    return streakMap;
  }

  // Optional: Add a method to format dates if needed
  String? formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}