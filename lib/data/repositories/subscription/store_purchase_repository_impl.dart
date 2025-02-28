import 'package:hungrx_app/data/Models/subcription_model/store_subscription.dart';
import 'package:hungrx_app/data/datasources/api/subscription_api.dart/store_purchase_api_client.dart';
import 'package:hungrx_app/data/repositories/subscription/store_purchase_repository.dart';

class StorePurchaseRepositoryImpl implements StorePurchaseRepository {
  final StorePurchaseApiClient _apiClient;

  StorePurchaseRepositoryImpl({
    required StorePurchaseApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<StorePurchaseResponseModel> storePurchaseDetails(
      StorePurchaseDetailsModel purchaseDetails) async {
    try {
      return await _apiClient.storePurchaseDetails(purchaseDetails);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
