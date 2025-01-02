import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/food_cart_screen.dart/delete_dish_cart_request.dart';

class DeleteDishCartApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<DeleteDishCartResponse> deleteDishFromCart(DeleteDishCartRequest request) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/removeOneItem'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return DeleteDishCartResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to delete dish from cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting dish from cart: $e');
    }
  }
}