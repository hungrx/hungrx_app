class WeightHistoryModel {
  final bool status;
  final String message;
  final bool isMetric;
  final double currentWeight;
  final List<WeightEntry> history;

  WeightHistoryModel({
    required this.status,
    required this.message,
    required this.isMetric,
    required this.currentWeight,
    required this.history,
  });

  factory WeightHistoryModel.fromJson(Map<String, dynamic> json) {
    return WeightHistoryModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      isMetric: json['isMetric'] ?? true,
      currentWeight: (json['currentWeight'] ?? 0).toDouble(),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => WeightEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class WeightEntry {
  final double weight;
  final String date;

  WeightEntry({required this.weight, required this.date});

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      weight: (json['weight'] ?? 0).toDouble(),
      date: json['date'] ?? '',
    );
  }

  String getFormattedDate() {
    // Return original string if it's "Current Weight"
    if (date == "Current Weight") return date;

    try {
      // Split the date string by '-'
      final parts = date.split('-');
      if (parts.length != 3) return date;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      
      // Add leading zero to day if needed
      String formattedDay = day.toString().padLeft(2, '0');
      
      return "$formattedDay-${months[month - 1]}-$year";
    } catch (e) {
      print('Date parsing error: $e for date: $date');
      return date;
    }
  }

  String getGraphDate() {
    // Return empty string if it's "Current Weight" to skip in graph
    if (date == "Current Weight") return "";

    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      
      // Add leading zero to day if needed
      String formattedDay = day.toString().padLeft(2, '0');
      
      return "$formattedDay-${months[month - 1]}";
    } catch (e) {
      print('Date parsing error: $e for date: $date');
      return date;
    }
  }
}