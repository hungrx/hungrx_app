class SubscriptionInfo {
  final bool isActive;
  final bool isCanceled;
  final String? expirationDate;
  final String? productIdentifier;
  final String? periodType;
  final String? latestPurchaseDate;
  final String? originalPurchaseDate;
  final String? store;
  final bool isSandbox;
  final bool willRenew;
  final String? ownershipType;
  final bool success;
  final String? error;
  final String? userId;
  final String? rcAppUserId;
  final String? productId;
  final String? offerType;
  final String? priceInLocalCurrency;
  final String? currencyCode;
  final String? purchaseToken; // For Android
  final String? transactionId; // For iOS

  SubscriptionInfo({
    this.isActive = false,
    this.isCanceled = false,
    this.expirationDate,
    this.productIdentifier,
    this.periodType,
    this.latestPurchaseDate,
    this.originalPurchaseDate,
    this.store,
    this.isSandbox = false,
    this.willRenew = false,
    this.ownershipType,
    this.success = false,
    this.error,
    this.userId,
    this.rcAppUserId,
    this.productId,
    this.offerType,
    this.priceInLocalCurrency,
    this.currencyCode,
    this.purchaseToken,
    this.transactionId,
  });
  
  // Add a factory method to create from error
  factory SubscriptionInfo.fromError(String errorCode) {
    return SubscriptionInfo(
      isActive: false,
      success: false,
      error: errorCode,
    );
  }
}