import 'package:hungrx_app/data/Models/food_cart_screen.dart/delete_dish_cart_request.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/delete_dish_cart_api.dart';

class DeleteDishCartRepository {
  final DeleteDishCartApi _api;

  DeleteDishCartRepository(this._api);

  Future<DeleteDishCartResponse> deleteDishFromCart(DeleteDishCartRequest request) async {
    try {
      return await _api.deleteDishFromCart(request);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
