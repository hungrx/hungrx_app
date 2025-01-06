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

  void _onLoadCart(LoadCart event, Emitter<GetCartState> emit) async {
    emit(CartLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(CartError('User not logged in'));
        return;
      }
      // print("userId2: $userId");
      final cartResponse = await cartRepository.getCart(userId); // Modified to get CartResponseModel
      final totalNutrition = _calculateTotalNutrition(cartResponse.data);
      emit(CartLoaded(
        carts: cartResponse.data,
        totalNutrition: totalNutrition,
        cartResponse: cartResponse,
        remaining: cartResponse.remaining
      ));
    } catch (e) {
      emit(CartError(e.toString()));
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
                restaurantId: dish.restaurantId,
                restaurantName: dish.restaurantName,
                categoryName: dish.categoryName,
                subCategoryName: dish.subCategoryName,
                dishId: dish.dishId,
                dishName: dish.dishName,
                servingSize: event.quantity.toString(),
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

  Map<String, double> _calculateTotalNutrition(List<CartModel> carts) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var cart in carts) {
      for (var dish in cart.dishDetails) {
        try {
          final servingSize = _parseServingSize(dish.servingSize);

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
