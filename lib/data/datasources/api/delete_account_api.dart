import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAccountApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com/users';

  Future<Map<String, dynamic>> deleteAccount(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteUser'),
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