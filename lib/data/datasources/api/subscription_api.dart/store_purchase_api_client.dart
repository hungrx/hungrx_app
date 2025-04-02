import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/subcription_model/store_subscription.dart';

class StorePurchaseApiClient {
  final http.Client _httpClient;

  StorePurchaseApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<StorePurchaseResponseModel> storePurchaseDetails(
      StorePurchaseDetailsModel purchaseDetails) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('${ApiConstants.baseUrl}/users/store'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(purchaseDetails.toMap()), // Changed from toJson() to toMap()
      );
      print(response.body);
print("update;;;;;;;;;;;;;;;${purchaseDetails.toMap()}");
      if (response.statusCode == 200) {
        return StorePurchaseResponseModel.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to store purchase details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error while storing purchase details: $e');
    }
  }
}

