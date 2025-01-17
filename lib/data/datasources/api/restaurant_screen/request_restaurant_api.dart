import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/restuarent_screen/request_restaurant_model.dart';

class RequestRestaurantApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> requestRestaurant(RequestRestaurantModel request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/reqrestaurant'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to request restaurant: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
