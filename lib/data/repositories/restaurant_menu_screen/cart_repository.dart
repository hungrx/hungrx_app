import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_response.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/cart_api.dart';

class CartRepository {
  final CartApi _api;

  CartRepository(this._api);

  Future<CartResponse> addToCart(CartRequest request) async {
    try {
      return await _api.addToCart(request);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}