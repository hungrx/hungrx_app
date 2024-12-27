import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_state.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;

  AddToCart(this.item);
}

class ClearCart extends CartEvent {}