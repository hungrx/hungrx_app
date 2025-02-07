import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_response.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/consume_cart_api.dart';

class ConsumeCartRepository {
  final ConsumeCartApi _api;

  ConsumeCartRepository(this._api);

  Future<ConsumeCartResponse> consumeCart(ConsumeCartRequest request) async {
    try {
      return await _api.consumeCart(request);
    } catch (e) {
      print(e);
      throw Exception('Repository error: $e');
    }
  }
}