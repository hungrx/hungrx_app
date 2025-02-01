import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/data/repositories/cart_screen/cart_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';

class GetCartBloc extends Bloc<GetCartEvent, GetCartState> {
  final GetCartRepository cartRepository;
  final AuthService _authService;

  GetCartBloc(
    this.cartRepository,
    this._authService,
  ) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<GetCartState> emit) async {
    emit(CartLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(CartError('Please log in to view your cart'));
        return;
      }

      final cartResponse = await cartRepository.getCart(userId);

      if (!cartResponse.success) {
        emit(CartError(cartResponse.message));
        return;
      }

      final totalNutrition = _calculateTotalNutrition(cartResponse.data);
      emit(CartLoaded(
          carts: cartResponse.data,
          totalNutrition: totalNutrition,
          cartResponse: cartResponse,
          remaining: cartResponse.remaining));
    } catch (e) {
      emit(CartError('Unable to load cart. Please try again later.'));
    }
  }

Map<String, double> _calculateTotalNutrition(List<CartModel> carts) {
  try {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var cart in carts) {
      for (var dish in cart.dishDetails) {
        try {
          final servingSize = _parseServingSize(dish.servingSize);
          final quantity = dish.quantity ?? 1; // Get the quantity and default to 1 if null

          final calories = double.tryParse(dish.nutritionInfo.calories.value) ?? 0;
          final protein = double.tryParse(dish.nutritionInfo.protein.value) ?? 0;
          final carbs = double.tryParse(dish.nutritionInfo.carbs.value) ?? 0;
          final fat = double.tryParse(dish.nutritionInfo.totalFat.value) ?? 0;

          // Multiply by both servingSize and quantity
          totalCalories += calories * servingSize * quantity;
          totalProtein += protein * servingSize * quantity;
          totalCarbs += carbs * servingSize * quantity;
          totalFat += fat * servingSize * quantity;
        } catch (e) {
          print("Error calculating nutrition for dish: ${dish.dishName}");
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
  } catch (e) {
    print("Error calculating total nutrition: $e");
    return {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fat': 0.0,
    };
  }
}

  void _onUpdateQuantity(UpdateQuantity event, Emitter<GetCartState> emit) async {
  final currentState = state;
  if (currentState is CartLoaded) {
    final updatedCarts = currentState.carts.map((cart) {
      if (cart.cartId == event.cartId) {
        final updatedDishDetails = cart.dishDetails.map((dish) {
          if (dish.dishId == event.dishId) {
            return DishDetail(
              quantity: event.quantity,  // Use the new quantity from the event
              url: dish.url,
              restaurantId: dish.restaurantId,
              restaurantName: dish.restaurantName,
              categoryName: dish.categoryName,
              subCategoryName: dish.subCategoryName,
              dishId: dish.dishId,
              dishName: dish.dishName,
              servingSize: dish.servingSize,  // Keep the original servingSize
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
    
    // Create updated CartResponseModel with the modified data
    final updatedCartResponse = CartResponseModel(
      success: currentState.cartResponse.success,
      message: currentState.cartResponse.message,
      data: updatedCarts,
      remaining: currentState.remaining
    );

    emit(CartLoaded(
      carts: updatedCarts,
      totalNutrition: totalNutrition,
      cartResponse: updatedCartResponse,
      remaining: currentState.remaining
    ));

    // Optional: Call API to persist the change
    // try {
    //   await cartRepository.updateQuantity(
    //     event.cartId,
    //     event.dishId,
    //     event.quantity,
    //   );
    // } catch (e) {
    //   print('Error updating quantity on server: $e');
    //   // You might want to emit an error state or revert the change
    // }
  }
}

  double _parseServingSize(String servingSize) {
    switch (servingSize.toLowerCase()) {
      case 'normal':
        return 1.0;
      case 'small':
        return 0.5;
      case 'large':
        return 1.5;
      default:
        try {
          return double.parse(servingSize);
        } catch (e) {
          return 1.0;
        }
    }
  }

  // Map<String, double> _calculateTotalNutrition(List<CartModel> carts) {
  //   double totalCalories = 0;
  //   double totalProtein = 0;
  //   double totalCarbs = 0;
  //   double totalFat = 0;

  //   for (var cart in carts) {
  //     for (var dish in cart.dishDetails) {
  //       try {
  //         final servingSize = _parseServingSize(dish.servingSize);

  //         final calories =
  //             double.tryParse(dish.nutritionInfo.calories.value) ?? 0;
  //         final protein =
  //             double.tryParse(dish.nutritionInfo.protein.value) ?? 0;
  //         final carbs = double.tryParse(dish.nutritionInfo.carbs.value) ?? 0;
  //         final fat = double.tryParse(dish.nutritionInfo.totalFat.value) ?? 0;

  //         totalCalories += calories * servingSize;
  //         totalProtein += protein * servingSize;
  //         totalCarbs += carbs * servingSize;
  //         totalFat += fat * servingSize;
  //       } catch (e) {
  //         continue;
  //       }
  //     }
  //   }

  //   return {
  //     'calories': totalCalories,
  //     'protein': totalProtein,
  //     'carbs': totalCarbs,
  //     'fat': totalFat,
  //   };
  // }
}
