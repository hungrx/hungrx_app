import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/cart_model.dart';
import 'package:hungrx_app/data/repositories/cart_screen/cart_repository.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';

class GetCartBloc extends Bloc<GetCartEvent, GetCartState> {
  final CartRepository cartRepository;

  GetCartBloc(this.cartRepository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  void _onLoadCart(LoadCart event, Emitter<GetCartState> emit) async {
    emit(CartLoading());
    try {
      final carts = await cartRepository.getCart(event.userId);
      final totalNutrition = _calculateTotalNutrition(carts);
      emit(CartLoaded(carts, totalNutrition));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onUpdateQuantity(
      UpdateQuantity event, Emitter<GetCartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedCarts = currentState.carts.map((cart) {
        if (cart.cartId == event.cartId) {
          final updatedDishDetails = cart.dishDetails.map((dish) {
            if (dish.dishId == event.dishId) {
              return DishDetail(
                restaurantId: dish.restaurantId,
                restaurantName: dish.restaurantName,
                categoryName: dish.categoryName,
                subCategoryName: dish.subCategoryName,
                dishId: dish.dishId,
                dishName: dish.dishName,
                servingSize:
                    event.quantity.toString(), // Store quantity in servingSize
                nutritionInfo: dish.nutritionInfo,
              );
            }
            return dish;
          }).toList();

          return CartModel(
            cartId: cart.cartId,
            orders: cart.orders,
            dishDetails: updatedDishDetails,
            createdAt: cart.createdAt,
          );
        }
        return cart;
      }).toList();

      final totalNutrition = _calculateTotalNutrition(updatedCarts);
      emit(CartLoaded(updatedCarts, totalNutrition));
    }
  }

  double _parseServingSize(String servingSize) {
    // Handle special serving size values
    switch (servingSize.toLowerCase()) {
      case 'normal':
        return 1.0;
      case 'small':
        return 0.5;
      case 'large':
        return 1.5;
      default:
        // Try to parse as number, return 1.0 if fails
        try {
          return double.parse(servingSize);
        } catch (e) {
          print(
              'Warning: Invalid serving size format: $servingSize, using default value 1.0');
          return 1.0;
        }
    }
  }

  Map<String, double> _calculateTotalNutrition(List<CartModel> carts) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var cart in carts) {
      for (var dish in cart.dishDetails) {
        try {
          final servingSize = _parseServingSize(dish.servingSize);

          // Parse nutrition values with error handling
          final calories =
              double.tryParse(dish.nutritionInfo.calories.value) ?? 0;
          final protein =
              double.tryParse(dish.nutritionInfo.protein.value) ?? 0;
          final carbs = double.tryParse(dish.nutritionInfo.carbs.value) ?? 0;
          final fat = double.tryParse(dish.nutritionInfo.totalFat.value) ?? 0;

          totalCalories += calories * servingSize;
          totalProtein += protein * servingSize;
          totalCarbs += carbs * servingSize;
          totalFat += fat * servingSize;
        } catch (e) {
          print('Error calculating nutrition for dish ${dish.dishName}: $e');
          // Continue processing other dishes even if one fails
          continue;
        }
      }
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }
}
