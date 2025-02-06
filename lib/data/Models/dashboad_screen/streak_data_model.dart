class StreakDataModel {
  final String userId;
  final String startingDate;
  final String? expectedEndDate;  // Make nullable
  final int? totalDays;          // Make nullable since it's not in the JSON
  final int? currentStreak;      // Make nullable since it's not in the JSON
  final int daysLeft;
  final List<String> dates;
  final bool status;
  final String message;

  StreakDataModel({
    required this.userId,
    required this.startingDate,
    this.expectedEndDate,        // Remove required
    this.totalDays,             // Remove required
    this.currentStreak,         // Remove required
    required this.daysLeft,
    required this.dates,
    required this.status,
    required this.message,
  });

  factory StreakDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return StreakDataModel(
      userId: data['userId'] as String,
      startingDate: data['startingDate'] as String,
      expectedEndDate: data['expectedEndDate'] as String?,  // Handle null
      totalDays: data['totalDays'] as int?,                // Handle null
      currentStreak: data['currentStreak'] as int?,        // Handle null
      daysLeft: data['daysLeft'] as int,
      dates: List<String>.from(data['dates'] ?? []),       // Provide empty list as default
      status: json['status'] as bool,
      message: json['message'] as String,
    );
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