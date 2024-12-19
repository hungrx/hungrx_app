class WeightEntry {
  final String newWeight;
  final String userId;
  final String dateTime;
  final String? loseweight;
  final String? gainweight;
  final bool? ismetric;
  final String? weightId;

  WeightEntry({
    required this.newWeight,
    required this.userId,
    required this.dateTime,
    this.loseweight,
    this.gainweight,
    this.ismetric,
    this.weightId,
  });

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      newWeight: json['newWeight'],
      userId: json['UserId'],
      dateTime: json['dateTime'],
      loseweight: json['loseweight'],
      gainweight: json['gainweight'],
      ismetric: json['ismetric'],
      weightId: json['weightId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newWeight': newWeight,
      'UserId': userId,
      'dateTime': dateTime,
    };
  }
}