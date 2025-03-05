

import 'package:hungrx_app/core/utils/api_exception.dart';
import 'package:hungrx_app/data/Models/subcription_model/verify_subscription.dart';
import 'package:hungrx_app/data/repositories/verify_subscription/verify_subscription_repository.dart';

class VerifySubscriptionUseCase {
  final VerifySubscriptionRepository _repository;

  VerifySubscriptionUseCase({required VerifySubscriptionRepository repository})
      : _repository = repository;

  Future<SubscriptionModel> execute(String userId) async {
    try {
      return await _repository.verifySubscription(userId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to verify subscription: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}