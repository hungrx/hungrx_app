import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

// GetCartApi class
class GetCartApi {
  Future<Map<String, dynamic>> getCart(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getCart),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      
      // Parse response body safely
      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'message': 'Failed to parse response',
          'data': [],
          'remaining': 0.0
        };
      }
      // Handle different response scenarios
      if (response.statusCode == 200) {
        // Check if response has expected structure
        if (responseData.containsKey('success') && 
            responseData.containsKey('data') &&
            responseData.containsKey('remaining')) {
          return responseData;
        } else {
          return {
            'success': false,
            'message': 'Invalid response format',
            'data': [],
            'remaining': 0.0
          };
        }
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'message': 'No cart found',
          'data': [],
          'remaining': 0.0
        };
      } else if (responseData['error']!.toString().contains('Topology is closed')) {
        return {
          'success': false,
          'message': 'Database connection error. Please try again.',
          'data': [],
          'remaining': 0.0
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to load cart',
          'data': [],
          'remaining': 0.0
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred. Please check your connection.',
        'data': [],
        'remaining': 0.0
      };
    }
  }
}