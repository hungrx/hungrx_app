abstract class DeleteDishCartEvent {}

class DeleteDishFromCart extends DeleteDishCartEvent {
  final String cartId;
  final String restaurantId;
  final String dishId;
  final String servingSize;

  DeleteDishFromCart({
    required this.cartId,
    required this.restaurantId,
    required this.dishId,
    required this.servingSize,
  });
}