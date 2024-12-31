import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';

abstract class AddToCartEvent {}

class SubmitAddToCartEvent extends AddToCartEvent {
  final CartRequest request;
  SubmitAddToCartEvent(this.request);
}