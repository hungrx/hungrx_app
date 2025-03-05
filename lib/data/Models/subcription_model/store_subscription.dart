class StorePurchaseDetailsModel {
  final String userId;
  final String rcAppUserId;
  final String productId;
  final String subscriptionLevel;
  final String expirationDate;
  final RevenuecatDetails revenuecatDetails;

  StorePurchaseDetailsModel({
    required this.userId,
    required this.rcAppUserId,
    required this.productId,
    required this.subscriptionLevel,
    required this.expirationDate,
    required this.revenuecatDetails,
  });

  factory StorePurchaseDetailsModel.fromMap(Map<String, dynamic> map) {
    return StorePurchaseDetailsModel(
      userId: map['userId'] ?? '',
      rcAppUserId: map['rcAppUserId'] ?? '',
      productId: map['productId'] ?? '',
      subscriptionLevel: map['subscriptionLevel'] ?? '',
      expirationDate: map['expirationDate'] ?? '',
      revenuecatDetails: RevenuecatDetails.fromMap(map['revenuecatDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rcAppUserId': rcAppUserId,
      'productId': productId,
      'subscriptionLevel': subscriptionLevel,
      'expirationDate': expirationDate,
      'revenuecatDetails': revenuecatDetails.toMap(),
    };
  }

  Map<String, dynamic> toJson() => toMap();
}

class RevenuecatDetails {
  final bool isCanceled;
  final String expirationDate;
  final String productIdentifier;
  final String periodType;
  final String latestPurchaseDate;
  final String originalPurchaseDate;
  final String store;
  final bool isSandbox;
  final bool willRenew;

  RevenuecatDetails({
    required this.isCanceled,
    required this.expirationDate,
    required this.productIdentifier,
    required this.periodType,
    required this.latestPurchaseDate,
    required this.originalPurchaseDate,
    required this.store,
    required this.isSandbox,
    required this.willRenew,
  });

  factory RevenuecatDetails.fromMap(Map<String, dynamic> map) {
    return RevenuecatDetails(
      isCanceled: map['isCanceled'] ?? false,
      expirationDate: map['expirationDate'] ?? '',
      productIdentifier: map['productIdentifier'] ?? '',
      periodType: map['periodType'] ?? '',
      latestPurchaseDate: map['latestPurchaseDate'] ?? '',
      originalPurchaseDate: map['originalPurchaseDate'] ?? '',
      store: map['store'] ?? '',
      isSandbox: map['isSandbox'] ?? false,
      willRenew: map['willRenew'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isCanceled': isCanceled,
      'expirationDate': expirationDate,
      'productIdentifier': productIdentifier,
      'periodType': periodType,
      'latestPurchaseDate': latestPurchaseDate,
      'originalPurchaseDate': originalPurchaseDate,
      'store': store,
      'isSandbox': isSandbox,
      'willRenew': willRenew,
    };
  }
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
