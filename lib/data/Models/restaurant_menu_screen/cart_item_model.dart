import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final String userId;
  final String restaurantId;
  final String dishId;
  final String servingSize;
  
  const CartItemModel({
    required this.userId,
    required this.restaurantId,
    required this.dishId,
    required this.servingSize,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'orders': [
      {
        'restaurantId': restaurantId,
        'items': [
          {
            'dishId': dishId,
            'servingSize': servingSize,
          }
        ]
      }
    ]
  };

  @override
  List<Object?> get props => [userId, restaurantId, dishId, servingSize];
}