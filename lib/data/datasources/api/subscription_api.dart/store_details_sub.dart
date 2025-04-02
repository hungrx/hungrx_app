import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/subcription_model/store_details_sub.dart';

class RevenueCatApiClient {
  final http.Client _httpClient;
  static const String _baseUrl = 'https://hungrx.xyz';

  RevenueCatApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<RevenueCatResponseModel> storeRevenueCatDetails(
      RevenueCatDetailsModel details) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/users/storeRevenueCatDetails'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(details.toJson()),
      );
      print("....>>>>>>>>>>>>>${details.toJson()}");
      print(" new api update ${response.body}");

      if (response.statusCode == 200) {
        return RevenueCatResponseModel.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to store RevenueCat details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error while storing RevenueCat details: $e');
    }
  }
}
