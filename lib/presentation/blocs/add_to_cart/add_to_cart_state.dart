import 'package:hungrx_app/data/Models/restaurant_menu_screen/add_cart_response.dart';

abstract class AddToCartState {}

class AddToCartInitial extends AddToCartState {}

class AddToCartLoading extends AddToCartState {}

class AddToCartSuccess extends AddToCartState {
  final AddToCartResponse response;

  AddToCartSuccess(this.response);
}

class AddToCartError extends AddToCartState {
  final String message;

  AddToCartError(this.message);
}
