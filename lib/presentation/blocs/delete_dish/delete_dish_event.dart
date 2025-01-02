abstract class DeleteDishCartEvent {}

class DeleteDishFromCart extends DeleteDishCartEvent {
  final String cartId;
  final String restaurantId;
  final String dishId;

  DeleteDishFromCart({
    required this.cartId,
    required this.restaurantId,
    required this.dishId,
  });
}