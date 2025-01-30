import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class EatScreenApiService {
  Future<Map<String, dynamic>> getEatScreenData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.eatPage),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch eat screen data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching eat screen data: $e');
    }
  }
}
