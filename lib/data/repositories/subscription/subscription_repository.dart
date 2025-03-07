import 'package:hungrx_app/data/Models/subcription_model/subscription_Info.dart';
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';

class SubscriptionRepository {
  Future<void> initialize() async {
    await PurchaseService.initialize();
  }

  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final packages = await PurchaseService.getPackages();
      return packages
          .map((package) => SubscriptionModel.fromPackage(package))
          .toList();
    } catch (e) {
      return [];
    }
  }

Future<SubscriptionInfo> purchaseSubscription(SubscriptionModel subscription) async {
  try {
    return await PurchaseService.purchasePackage(subscription.package);
  } catch (e) {
    rethrow;
  }
}

  Future<bool> isPremiumUser() async {
    return await PurchaseService.isUserPremium();
  }

 Future<bool> restorePurchases() async {
  return await PurchaseService.restorePurchases();
}

// Add to SubscriptionRepository
Future<void> identifyUser(String userId) async {
  await PurchaseService.identifyUser(userId);
}

Future<Map<String, dynamic>?> getSubscriptionDetails() async {
  return await PurchaseService.getActiveSubscriptionDetails();
}

// Add to SubscriptionRepository
Future<void> debugSubscriptions() async {
  await PurchaseService.debugOfferings();
}
}
