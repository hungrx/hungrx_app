class ReferralModel {
  final String userId;
  final String referralCode;
  final bool isNewCode;

  ReferralModel({
    required this.userId,
    required this.referralCode,
    required this.isNewCode,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      userId: json['userId'] ?? '',
      referralCode: json['referralCode'] ?? '',
      isNewCode: json['isNewCode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'referralCode': referralCode,
      'isNewCode': isNewCode,
    };
  }
}