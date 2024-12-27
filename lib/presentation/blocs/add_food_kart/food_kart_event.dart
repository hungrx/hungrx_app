import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final CartItemModel item;

  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}
