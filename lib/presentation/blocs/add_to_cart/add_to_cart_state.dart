import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_response.dart';

abstract class AddToCartState {}

class AddToCartInitial extends AddToCartState {}

class AddToCartLoading extends AddToCartState {}

class AddToCartSuccess extends AddToCartState {
  final CartResponse response;

  AddToCartSuccess(this.response);
}

class AddToCartError extends AddToCartState {
  final String message;

  AddToCartError(this.message);
}