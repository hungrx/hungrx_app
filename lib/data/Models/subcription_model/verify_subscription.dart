class SubscriptionModel {
  final bool success;
  final String userId;
  final String rcAppUserId;
  final String productId;
  final bool isSubscribed;
  final String subscriptionLevel;
  final DateTime expirationDate;
  final bool isValid;
  final bool fromCache;
  final RevenueCatDetails revenuecatDetails;

  SubscriptionModel({
    required this.success,
    required this.userId,
    required this.rcAppUserId,
    required this.productId,
    required this.isSubscribed,
    required this.subscriptionLevel,
    required this.expirationDate,
    required this.isValid,
    required this.fromCache,
    required this.revenuecatDetails,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      success: json['success'] ?? false,
      userId: json['userId'] ?? '',
      rcAppUserId: json['rcAppUserId'] ?? '',
      productId: json['productId'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      subscriptionLevel: json['subscriptionLevel'] ?? 'none',
      expirationDate: DateTime.parse(json['expirationDate'] ?? DateTime.now().toIso8601String()),
      isValid: json['isValid'] ?? false,
      fromCache: json['fromCache'] ?? false,
      revenuecatDetails: RevenueCatDetails.fromJson(json['revenuecatDetails'] ?? {}),
    );
  }
}

class RevenueCatDetails {
  final bool isCanceled;
  final DateTime expirationDate;
  final String productIdentifier;
  final String periodType;
  final DateTime latestPurchaseDate;
  final DateTime originalPurchaseDate;
  final String store;
  final bool isSandbox;
  final bool willRenew;

  RevenueCatDetails({
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

  factory RevenueCatDetails.fromJson(Map<String, dynamic> json) {
    return RevenueCatDetails(
      isCanceled: json['isCanceled'] ?? false,
      expirationDate: DateTime.parse(json['expirationDate'] ?? DateTime.now().toIso8601String()),
      productIdentifier: json['productIdentifier'] ?? '',
      periodType: json['periodType'] ?? '',
      latestPurchaseDate: DateTime.parse(json['latestPurchaseDate'] ?? DateTime.now().toIso8601String()),
      originalPurchaseDate: DateTime.parse(json['originalPurchaseDate'] ?? DateTime.now().toIso8601String()),
      store: json['store'] ?? '',
      isSandbox: json['isSandbox'] ?? false,
      willRenew: json['willRenew'] ?? false,
    );
  }
}