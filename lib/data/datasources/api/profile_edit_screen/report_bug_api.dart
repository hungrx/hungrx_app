import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class ReportBugApi {
  Future<Map<String, dynamic>> reportBug(String userId, String report) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.bug),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'report': report,
        }),
      );
// print(response.body);
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit bug report');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}