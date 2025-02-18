class TimezoneModel {
  final String userId;
  final String timezone;

  TimezoneModel({required this.userId, required this.timezone});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'timezone': timezone,
      };

  factory TimezoneModel.fromJson(Map<String, dynamic> json) {
    return TimezoneModel(
      userId: json['userId'] as String,
      timezone: json['timezone'] as String,
    );
  }
}