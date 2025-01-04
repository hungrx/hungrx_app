import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_response.dart';
import 'package:hungrx_app/data/repositories/cart_screen/consume_cart_repository.dart';

class ConsumeCartUseCase {
  final ConsumeCartRepository _repository;

  ConsumeCartUseCase(this._repository);

  Future<ConsumeCartResponse> execute(ConsumeCartRequest request) async {
    try {
      return await _repository.consumeCart(request);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}