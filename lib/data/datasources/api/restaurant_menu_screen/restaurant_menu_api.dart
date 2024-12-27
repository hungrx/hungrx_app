import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';

class RestaurantMenuApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<RestaurantMenuResponse> getMenu(
      String restaurantId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/getMenu'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'restaurantId': restaurantId,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        return RestaurantMenuResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load menu: $e');
    }
  }
}
