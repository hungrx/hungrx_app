class WeightUpdateModel {
  final String userId;
  final double newWeight;

  WeightUpdateModel({required this.userId, required this.newWeight});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'newWeight': newWeight,
      };

  factory WeightUpdateModel.fromJson(Map<String, dynamic> json) {
    return WeightUpdateModel(
      userId: json['userId'],
      newWeight: json['newWeight'].toDouble(),
    );
  }
}