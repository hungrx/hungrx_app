class DeleteDishCartRequest {
  final String cartId;
  final String restaurantId;
  final String dishId;
  final String servingSize;

  DeleteDishCartRequest({
    required this.cartId,
    required this.restaurantId,
    required this.dishId,
    required this.servingSize,
  });

  Map<String, dynamic> toJson() => {
        'cartId': cartId,
        'restaurantId': restaurantId,
        'dishId': dishId,
        'servingSize': servingSize,
      };
}

class DeleteDishCartResponse {
  final bool status;
  final String message;

  DeleteDishCartResponse({
    required this.status,
    required this.message,
  });

  factory DeleteDishCartResponse.fromJson(Map<String, dynamic> json) {
    return DeleteDishCartResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error occurred',
    );
  }
}