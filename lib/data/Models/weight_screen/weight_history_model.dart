class WeightHistoryModel {
  final bool status;
  final String message;
  final bool isMetric;
  final double currentWeight;
  final double initialWeight;
  final List<WeightEntry> history;
  final DateTime lastUpdated;

  WeightHistoryModel({
    required this.status,
    required this.message,
    required this.isMetric,
    required this.currentWeight,
    required this.initialWeight,
    required this.history,
    required this.lastUpdated,
  });

  factory WeightHistoryModel.fromJson(Map<String, dynamic> json) {
    return WeightHistoryModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      isMetric: json['isMetric'] ?? true,
      currentWeight: (json['currentWeight'] ?? 0).toDouble(),
      initialWeight: (json['initialWeight'] ?? 0).toDouble(),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => WeightEntry.fromJson(e))
              .toList() ??
          [],
      lastUpdated: DateTime.parse(
          json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'isMetric': isMetric,
        'currentWeight': currentWeight,
        'initialWeight': initialWeight,
        'history': history.map((e) => e.toJson()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  bool equals(WeightHistoryModel other) {
    return currentWeight == other.currentWeight &&
        history.length == other.history.length &&
        lastUpdated == other.lastUpdated;
  }
}

class WeightEntry {
  final double weight;
  final DateTime date;

  WeightEntry({required this.weight, required this.date});

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      weight: (json['weight'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'date': date.toIso8601String(),
      };

  String getFormattedDate() {
    if (date == DateTime(1970, 1, 1)) return "Initial weight";

    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    String formattedDay = date.day.toString().padLeft(2, '0');
    return "$formattedDay-${months[date.month - 1]}-${date.year}";
  }

  String getGraphDate() {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    String formattedDay = date.day.toString().padLeft(2, '0');
    return "$formattedDay-${months[date.month - 1]}";
  }
}
