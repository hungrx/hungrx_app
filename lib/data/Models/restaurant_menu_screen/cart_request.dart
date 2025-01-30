class CartRequest {
  final String? userId; // Made nullable since it will be added later
  final List<CartOrderRequest> orders;

  CartRequest({
    this.userId, // Made optional
    required this.orders,
  });
Future<CartRequest> copyWithUserId(String userId) async {
    return CartRequest(
      userId: userId,
      orders: orders,
    );
  }
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'orders': orders.map((order) => order.toJson()).toList(),
      };
}

class CartOrderRequest {
  final String restaurantId;
  final List<CartItemRequest> items;

  CartOrderRequest({required this.restaurantId, required this.items});

  Map<String, dynamic> toJson() => {
        'restaurantId': restaurantId,
        'items': items.map((item) => item.toJson()).toList(),
      };
}

class CartItemRequest {
  final String dishId;
  final String servingSize;
  final int quantity; // Added quantity field

  CartItemRequest({
    required this.dishId, 
    required this.servingSize,
    required this.quantity, // Made quantity required
  });

  Map<String, dynamic> toJson() => {
        'dishId': dishId,
        'servingSize': servingSize,
        'quantity': quantity, // Added quantity to JSON
      };
}
