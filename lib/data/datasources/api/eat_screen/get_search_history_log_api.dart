import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/home_meals_screen/get_search_history_log_response.dart';

class GetSearchHistoryLogApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';
  final http.Client client;

  GetSearchHistoryLogApi({http.Client? client}) : client = client ?? http.Client();

  Future<GetSearchHistoryLogResponse> getSearchHistory(String userId) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/users/getUserhistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
//       print(userId);
// print(response.body);
      if (response.statusCode == 200) {
        return GetSearchHistoryLogResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load search history');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}