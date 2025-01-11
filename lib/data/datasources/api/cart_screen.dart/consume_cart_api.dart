import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_response.dart';

class ConsumeCartApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<ConsumeCartResponse> consumeCart(ConsumeCartRequest request) async {
    print(request.mealType);
    print(request.orderDetails.first.dishId);
    print(request.userId);
    print(request.orderDetails.first.quantity);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/removeCart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
print(response.body);
      if (response.statusCode == 200) {
        return ConsumeCartResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to consume cart: ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to server: $e');
    }
  }
}