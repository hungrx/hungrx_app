// lib/domain/usecases/subscription_usecase.dart
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';
import 'package:hungrx_app/data/repositories/subscription/subscription_repository.dart';

class SubscriptionUseCase {
  final SubscriptionRepository _repository;

  SubscriptionUseCase(this._repository);

  Future<void> initialize() async {
    await _repository.initialize();
  }

  Future<List<SubscriptionModel>> getSubscriptions() async {
    return await _repository.getSubscriptions();
  }

  Future<bool> purchaseSubscription(SubscriptionModel subscription) async {
    return await _repository.purchaseSubscription(subscription);
  }

  Future<bool> isPremiumUser() async {
    return await _repository.isPremiumUser();
  }
  // Add to SubscriptionUseCase
Future<bool> restorePurchases() async {
  return await _repository.restorePurchases();
}
}