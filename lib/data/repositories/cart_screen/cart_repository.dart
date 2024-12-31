import 'package:hungrx_app/data/Models/food_cart_screen.dart/cart_model.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/cart_api.dart';

class CartRepository {
  final CartApi _cartApi;

  CartRepository(this._cartApi);

  Future<List<CartModel>> getCart(String userId) async {
    try {
      final response = await _cartApi.getCart(userId);
      if (response['success']) {
        return (response['data'] as List)
            .map((cart) => CartModel.fromJson(cart))
            .toList();
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      print("nwqw : $e");
      throw Exception('Failed to fetch cart: $e');
    }
  }
}
