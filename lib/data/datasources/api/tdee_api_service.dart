import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import '../../../core/utils/api_exception.dart';

class TDEEApiService {
  final http.Client _client;

  TDEEApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> calculateMetrics(String userId) async {
  
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.calculateMetricsEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'userId': userId}),
      );
      final decodedResponse = json.decode(response.body);
print(response.body);
      if (response.statusCode == 200) {
        return decodedResponse['data'];
      } else {
        throw ApiException(
          message: decodedResponse['message'] ?? 'Failed to calculate metrics',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Error calculating metrics: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
