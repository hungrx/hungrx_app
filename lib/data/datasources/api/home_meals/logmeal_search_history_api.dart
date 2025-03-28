import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class LogMealSearchHistoryApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> addToHistory({
    required String userId,
    required String productId,
  }) async {
    // print(productId);
    try {
      if (userId.isEmpty || productId.isEmpty) {
      throw Exception('userId and productId cannot be empty');
    }



      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.addHistory),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'productId': productId,
        }),
      );
// print("User history added log :${response.body}");
// print(response.body);
// print(response.statusCode);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add to history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}