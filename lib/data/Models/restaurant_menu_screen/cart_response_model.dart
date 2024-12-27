

import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_screen.dart';

class CartResponseModel {
  final bool status;
  final String message;
  final List<DishDetails> dishes;

  CartResponseModel({
    required this.status,
    required this.message,
    required this.dishes,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      dishes: (json['dishes'] as List?)
          ?.map((dish) => DishDetails.fromJson(dish))
          .toList() ?? [],
    );
  }
}