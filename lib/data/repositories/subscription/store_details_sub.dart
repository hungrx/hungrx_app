import 'package:hungrx_app/data/Models/subcription_model/store_details_sub.dart';
import 'package:hungrx_app/data/datasources/api/subscription_api.dart/store_details_sub.dart';

abstract class RevenueCatRepository {
  Future<RevenueCatResponseModel> storeRevenueCatDetails(
      RevenueCatDetailsModel details);
}

class RevenueCatRepositoryImpl implements RevenueCatRepository {
  final RevenueCatApiClient _apiClient;

  RevenueCatRepositoryImpl({
    required RevenueCatApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<RevenueCatResponseModel> storeRevenueCatDetails(
      RevenueCatDetailsModel details) async {
    try {
      return await _apiClient.storeRevenueCatDetails(details);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
