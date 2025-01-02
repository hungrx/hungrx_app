import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/add_cart_response.dart';

class AddToCartApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<AddToCartResponse> addToCart(CartRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/addToCart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
// print(response.body);
      if (response.statusCode == 200) {
        return AddToCartResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
