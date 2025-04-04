abstract class GetCartEvent {}

class LoadCart extends GetCartEvent {
  LoadCart();
}
class LoadCachedCart extends GetCartEvent {
  LoadCachedCart();
}
class UpdateQuantity extends GetCartEvent {
  final String cartId;
  final String dishId;
  final int quantity;

  UpdateQuantity({
    required this.cartId,
    required this.dishId,
    required this.quantity,
  });
}