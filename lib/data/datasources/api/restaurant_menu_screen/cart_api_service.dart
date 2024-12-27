import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_item_model.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_response_model.dart';

class CartApiService {
  static const baseUrl = 'https://hungrxbackend.onrender.com';

  Future<CartResponseModel> addToCart(CartItemModel cartItem) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/addToCart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cartItem.toJson()),
      );

      if (response.statusCode == 200) {
        return CartResponseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}