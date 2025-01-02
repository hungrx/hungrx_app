import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/add_cart_response.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/add_to_cart.dart';

class AddToCartRepository {
  final AddToCartApi _api;

  AddToCartRepository(this._api);

  Future<AddToCartResponse> addToCart(CartRequest request) async {
    try {
      return await _api.addToCart(request);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
