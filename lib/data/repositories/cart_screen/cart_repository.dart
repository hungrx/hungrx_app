import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/get_cart_api.dart';
import 'package:http/http.dart' as http;

class GetCartRepository {
  final GetCartApi _cartApi;

  GetCartRepository(this._cartApi);

  Future<CartResponseModel> getCart(String userId) async {
    try {
      final response = await _cartApi.getCart(userId);

      // Create CartResponseModel with safe defaults if parsing fails
      try {
        final cartResponse = CartResponseModel.fromJson(response);
        return cartResponse;
      } catch (e) {
        return CartResponseModel(
            success: false,
            message: 'Failed to parse cart data',
            data: [],
            remaining: 0.0);
      }
    } catch (e) {
      return CartResponseModel(
          success: false,
          message: 'Failed to fetch cart. Please try again.',
          data: [],
          remaining: 0.0);
    }
  }

  Future<bool> updateQuantity({
    required String cartId,
    required List<Map<String, dynamic>> items,
  }) async {
    print("............$cartId");
    print("............$items");
    try {
      final uri =
          Uri.parse('https://hungrxbackend.onrender.com/users/updateQuantity');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cartId': cartId,
          'items': items,
        }),
      );
      print("..................${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      return false;
    }
  }
}
