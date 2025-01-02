class DeleteDishCartRequest {
  final String cartId;
  final String restaurantId;
  final String dishId;

  DeleteDishCartRequest({
    required this.cartId,
    required this.restaurantId,
    required this.dishId,
  });

  Map<String, dynamic> toJson() => {
        'cartId': cartId,
        'restaurantId': restaurantId,
        'dishId': dishId,
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