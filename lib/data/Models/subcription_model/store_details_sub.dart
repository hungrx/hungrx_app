class RevenueCatDetailsModel {
  final String userId;
  final String rcAppUserId;  // Added this new field
  final RevenueCatInfo revenueCatDetails;

  RevenueCatDetailsModel({
    required this.userId,
    required this.rcAppUserId,  // Added to constructor
    required this.revenueCatDetails,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'rcAppUserId': rcAppUserId,  // Added to toJson
    'revenueCatDetails': revenueCatDetails.toJson(),
  };

  factory RevenueCatDetailsModel.fromJson(Map<String, dynamic> json) => 
    RevenueCatDetailsModel(
      userId: json['userId'] ?? '',
      rcAppUserId: json['rcAppUserId'] ?? '',  // Added to fromJson
      revenueCatDetails: RevenueCatInfo.fromJson(
        json['revenueCatDetails'] ?? {}
      ),
    );
}

class RevenueCatInfo {
  final bool isCanceled;
  final String expirationDate;
  final String productIdentifier;
  final String periodType;
  final String latestPurchaseDate;
  final String originalPurchaseDate;
  final String store;
  final bool isSandbox;
  final bool willRenew;

  RevenueCatInfo({
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

  Map<String, dynamic> toJson() => {
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

  factory RevenueCatInfo.fromJson(Map<String, dynamic> json) => RevenueCatInfo(
    isCanceled: json['isCanceled'] ?? false,
    expirationDate: json['expirationDate'] ?? '',
    productIdentifier: json['productIdentifier'] ?? '',
    periodType: json['periodType'] ?? '',
    latestPurchaseDate: json['latestPurchaseDate'] ?? '',
    originalPurchaseDate: json['originalPurchaseDate'] ?? '',
    store: json['store'] ?? '',
    isSandbox: json['isSandbox'] ?? false,
    willRenew: json['willRenew'] ?? false,
  );
}

class RevenueCatResponseModel {
  final bool success;
  final String message;
  final bool isSubscribed;
  final String subscriptionLevel;

  RevenueCatResponseModel({
    required this.success,
    required this.message,
    required this.isSubscribed,
    required this.subscriptionLevel,
  });

  factory RevenueCatResponseModel.fromJson(Map<String, dynamic> json) =>
    RevenueCatResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      subscriptionLevel: json['subscriptionLevel'] ?? '',
    );
}