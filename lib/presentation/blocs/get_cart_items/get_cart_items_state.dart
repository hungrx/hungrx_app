import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';

abstract class GetCartState {}

class CartInitial extends GetCartState {}

class CartLoading extends GetCartState {}

class CartLoaded extends GetCartState {
  final List<CartModel> carts;
  final Map<String, double> totalNutrition;
  final CartResponseModel cartResponse;
   final bool pendingSync;
  final double remaining;
   final String? syncError;

  CartLoaded({
    required this.carts,
    required this.totalNutrition,
    required this.cartResponse,
     this.pendingSync = false,
    required this.remaining,
    this.syncError,
  });
}

class CartError extends GetCartState {
  final String message;
  CartError(this.message);
}

class CartSyncing extends GetCartState {
  final String dishId;
  
  CartSyncing(this.dishId);
}