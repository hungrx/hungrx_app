import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';

abstract class GetCartState {}

class CartInitial extends GetCartState {}

class CartLoading extends GetCartState {}

class CartLoaded extends GetCartState {
  final List<CartModel> carts;
  final Map<String, double> totalNutrition;
  final CartResponseModel cartResponse;
  final double remaining;

  CartLoaded({
    required this.carts,
    required this.totalNutrition,
    required this.cartResponse,
    required this.remaining,
  });
}

class CartError extends GetCartState {
  final String message;
  CartError(this.message);
}
