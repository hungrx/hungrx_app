import 'package:hungrx_app/data/Models/food_cart_screen.dart/delete_dish_cart_request.dart';
import 'package:hungrx_app/data/repositories/cart_screen/delete_dish_cart_repository.dart';

class DeleteDishCartUseCase {
  final DeleteDishCartRepository _repository;

  DeleteDishCartUseCase(this._repository);

  Future<DeleteDishCartResponse> execute(DeleteDishCartRequest request) async {
    try {
      return await _repository.deleteDishFromCart(request);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}