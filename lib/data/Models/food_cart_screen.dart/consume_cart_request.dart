class ConsumeCartRequest {
  final String userId;
  final String mealType;
  final List<OrderDetail> orderDetails;

  ConsumeCartRequest({
    required this.userId,
    required this.mealType,
    required this.orderDetails,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'mealType': mealType,
        'orderDetails': orderDetails.map((detail) => detail.toJson()).toList(),
      };
}

class OrderDetail {
  final String dishId;
  final int quantity;

  OrderDetail({required this.dishId, required this.quantity});

  Map<String, dynamic> toJson() => {
        'dishId': dishId,
        'quantity': quantity,
      };
}