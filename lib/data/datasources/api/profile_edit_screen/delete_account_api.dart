import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class DeleteAccountApi {
  Future<Map<String, dynamic>> deleteAccount(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteUser),
        body: jsonEncode({'userId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to delete account: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
