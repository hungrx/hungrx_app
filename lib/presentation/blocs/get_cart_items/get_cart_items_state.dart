import 'package:hungrx_app/data/Models/food_cart_screen.dart/cart_model.dart';

abstract class GetCartState {}

class CartInitial extends GetCartState {}

class CartLoading extends GetCartState {}

class CartLoaded extends GetCartState {
  final List<CartModel> carts;
  final Map<String, double> totalNutrition;

  CartLoaded(this.carts, this.totalNutrition);
}

class CartError extends GetCartState {
  final String message;
  CartError(this.message);
}