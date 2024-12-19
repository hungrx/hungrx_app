class FeedbackModel {
  final String userId;
  final int stars;
  final String description;

  FeedbackModel({
    required this.userId,
    required this.stars,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'stars': stars,
      'description': description,
    };
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      userId: json['userId'],
      stars: json['stars'],
      description: json['description'],
    );
  }
}