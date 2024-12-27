import 'package:equatable/equatable.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_screen.dart';

class CartItem {
  final String dishName;
  final String size;
  final NutritionInfo nutritionInfo;

  CartItem({
    required this.dishName,
    required this.size,
    required this.nutritionInfo,
  });
}

class CartState extends Equatable {
  final List<CartItem> items;
  final double totalCalories;
  
  const CartState({
    this.items = const [],
    this.totalCalories = 0.0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? totalCalories,
  }) {
    return CartState(
      items: items ?? this.items,
      totalCalories: totalCalories ?? this.totalCalories,
    );
  }

  @override
  List<Object?> get props => [items, totalCalories];
}