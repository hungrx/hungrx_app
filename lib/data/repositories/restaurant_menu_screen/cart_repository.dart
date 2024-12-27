import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_item_model.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_response_model.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/cart_api_service.dart';

class CartRepository {
  final CartApiService _apiService;

  CartRepository(this._apiService);

  Future<CartResponseModel> addItemToCart(CartItemModel item) async {
    try {
      return await _apiService.addToCart(item);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
