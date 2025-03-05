import 'package:hungrx_app/core/utils/api_exception.dart';
import 'package:hungrx_app/data/Models/subcription_model/verify_subscription.dart';
import 'package:hungrx_app/data/datasources/api/verify_subscription.dart/verify_subscription.dart';


class VerifySubscriptionRepository {
  final VerifySubscriptionApiClient _apiClient;

  VerifySubscriptionRepository({required VerifySubscriptionApiClient apiClient})
      : _apiClient = apiClient;

  Future<SubscriptionModel> verifySubscription(String userId) async {
    try {
      final response = await _apiClient.verifySubscription(userId);
      return SubscriptionModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}