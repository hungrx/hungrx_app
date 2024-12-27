import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_item_model.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_response_model.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<CartResponseModel> execute(CartItemModel item) async {
    try {
      return await repository.addItemToCart(item);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}