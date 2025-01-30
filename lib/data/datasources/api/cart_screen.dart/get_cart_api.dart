import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class GetCartApi {
  Future<Map<String, dynamic>> getCart(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getCart),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Return a valid response structure even when cart is empty
        return {
          'success': true,
          'message': 'No cart found',
          'data': [],
          'remaining': 0.0
        };
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
