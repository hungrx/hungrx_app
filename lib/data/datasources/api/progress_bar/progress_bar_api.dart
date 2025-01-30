import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class ProgressBarApi {
  Future<Map<String, dynamic>> fetchProgressBarData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.progressBar),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return responseData['data'];
        } else {
          throw Exception('API returned false status');
        }
      } else {
        throw Exception('Failed to fetch progress bar data');
      }
    } catch (e) {
      throw Exception('Error fetching progress bar data: $e');
    }
  }
}
