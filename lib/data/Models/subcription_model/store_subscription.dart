class StorePurchaseDetailsModel {
  final String userId;
  final String rcAppUserId;
  final String productId;
  final String purchaseToken;
  final String transactionId;
  final String offerType;
  final String priceInLocalCurrency;
  final String currencyCode;

  StorePurchaseDetailsModel({
    required this.userId,
    required this.rcAppUserId,
    required this.productId,
    required this.purchaseToken,
    required this.transactionId,
    required this.offerType,
    required this.priceInLocalCurrency,
    required this.currencyCode,
  });

  // Factory constructor to create a model from a Map
  factory StorePurchaseDetailsModel.fromMap(Map<String, dynamic> map) {
    return StorePurchaseDetailsModel(
      userId: map['userId'] ?? '',
      rcAppUserId: map['rcAppUserId'] ?? '',
      productId: map['productId'] ?? '',
      purchaseToken: map['purchaseToken'] ?? '',
      transactionId: map['transactionId'] ?? '',
      offerType: map['offerType'] ?? '',
      priceInLocalCurrency: map['priceInLocalCurrency'] ?? '',
      currencyCode: map['currencyCode'] ?? '',
    );
  }

  // Convert model to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rcAppUserId': rcAppUserId,
      'productId': productId,
      'purchaseToken': purchaseToken,
      'transactionId': transactionId,
      'offerType': offerType,
      'priceInLocalCurrency': priceInLocalCurrency,
      'currencyCode': currencyCode,
    };
  }

  // Method for JSON serialization (alias for toMap)
  Map<String, dynamic> toJson() => toMap();
}

// Response model
class StorePurchaseResponseModel {
  final bool success;
  final String message;
  final bool isSubscribed;
  final String subscriptionLevel;

  StorePurchaseResponseModel({
    required this.success,
    required this.message,
    required this.isSubscribed,
    required this.subscriptionLevel,
  });

  factory StorePurchaseResponseModel.fromJson(Map<String, dynamic> json) =>
      StorePurchaseResponseModel(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        isSubscribed: json['isSubscribed'] ?? false,
        subscriptionLevel: json['subscriptionLevel'] ?? '',
      );
}
