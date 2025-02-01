import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/get_cart_api.dart';

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
        print("Error parsing cart response: $e");
        return CartResponseModel(
          success: false,
          message: 'Failed to parse cart data',
          data: [],
          remaining: 0.0
        );
      }
    } catch (e) {
      print("Error fetching cart: $e");
      return CartResponseModel(
        success: false,
        message: 'Failed to fetch cart. Please try again.',
        data: [],
        remaining: 0.0
      );
    }
  }
}
