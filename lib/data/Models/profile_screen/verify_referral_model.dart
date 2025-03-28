class VerifyReferralModel {
  final String userId;
  final String referralCode;
  final String expirationDate;

  VerifyReferralModel({
    required this.userId,
    required this.referralCode,
    required this.expirationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'referralCode': referralCode,
      'expirationDate': expirationDate,
    };
  }

  factory VerifyReferralModel.fromJson(Map<String, dynamic> json) {
    return VerifyReferralModel(
      userId: json['userId'] as String,
      referralCode: json['referralCode'] as String,
      expirationDate: json['expirationDate'] as String,
    );
  }
}
