import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/add_cart_response.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/cart_repository.dart';

class AddToCartUseCase {
  final AddToCartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<AddToCartResponse> execute(CartRequest request) async {
    try {
      return await _repository.addToCart(request);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}
