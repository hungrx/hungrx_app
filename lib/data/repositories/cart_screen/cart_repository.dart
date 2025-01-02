import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/get_cart_api.dart';

class GetCartRepository {
  final GetCartApi _cartApi;

  GetCartRepository(this._cartApi);

  Future<CartResponseModel> getCart(String userId) async {
    try {
      final response = await _cartApi.getCart(userId);
      final cartResponse = CartResponseModel.fromJson(response);
      
      if (cartResponse.success) {
        return cartResponse;
      } else {
        throw Exception(cartResponse.message);
      }
    } catch (e) {
      print("Error fetching cart: $e");
      throw Exception('Failed to fetch cart: $e');
    }
  }
}
