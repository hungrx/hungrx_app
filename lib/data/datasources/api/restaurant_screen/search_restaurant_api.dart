import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SearchRestaurantApi {
  static const baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> searchRestaurants(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/searchRestaurant'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': query}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timed out');
        },
      );

      print(response.body);
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // If restaurant not found, still return the response instead of throwing
        if (responseData['status'] == false) {
          return responseData; // Returns {"status":false,"message":"Restaurant not found"}
        }
        return responseData;
      } else {
        throw Exception('Failed to search restaurants');
      }
      
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}