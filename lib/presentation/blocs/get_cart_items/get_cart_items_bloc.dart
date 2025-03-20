import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/data/repositories/cart_screen/cart_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCartBloc extends Bloc<GetCartEvent, GetCartState> {
  final GetCartRepository cartRepository;
  final AuthService _authService;
  CartResponseModel? _cachedCart;
  Timer? _debounceTimer;
  Map<String, List<PendingUpdate>> _pendingUpdates = {};

  GetCartBloc(
    this.cartRepository,
    this._authService,
  ) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<LoadCachedCart>(_onLoadCachedCart);
  }

  Future<void> _onLoadCachedCart(
    LoadCachedCart event,
    Emitter<GetCartState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cart_cache');

      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        _cachedCart = CartResponseModel.fromJson(jsonData);
        final totalNutrition = _calculateTotalNutrition(_cachedCart!.data);
        emit(CartLoaded(
          carts: _cachedCart!.data,
          totalNutrition: totalNutrition,
          cartResponse: _cachedCart!,
          remaining: _cachedCart!.remaining,
        ));
      }
    } catch (e) {
      debugPrint('Error loading cached cart: $e');
    }
  }

  Future<void> _cacheCartData(CartResponseModel cartData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_cache', json.encode(cartData.toJson()));
    } catch (e) {
      debugPrint('Error caching cart data: $e');
    }
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<GetCartState> emit) async {
    // If we have cached data, emit it first
    if (_cachedCart != null) {
      final totalNutrition = _calculateTotalNutrition(_cachedCart!.data);
      emit(CartLoaded(
        carts: _cachedCart!.data,
        totalNutrition: totalNutrition,
        cartResponse: _cachedCart!,
        remaining: _cachedCart!.remaining,
      ));
    } else {
      emit(CartLoading());
    }

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(CartError('Please log in to view your cart'));
        return;
      }

      final cartResponse = await cartRepository.getCart(userId);

      if (!cartResponse.success) {
        if (_cachedCart == null) {
          emit(CartError(cartResponse.message));
        }
        return;
      }

      // Compare with cached data before emitting
      if (_cachedCart == null ||
          !_compareCartResponses(_cachedCart!, cartResponse)) {
        _cachedCart = cartResponse;
        final totalNutrition = _calculateTotalNutrition(cartResponse.data);
        emit(CartLoaded(
          carts: cartResponse.data,
          totalNutrition: totalNutrition,
          cartResponse: cartResponse,
          remaining: cartResponse.remaining,
        ));

        // Update cache
        await _cacheCartData(cartResponse);
      }
    } catch (e) {
      if (_cachedCart == null) {
        emit(CartError('Unable to load cart. Please try again later.'));
      }
    }
  }

  bool _compareCartResponses(
      CartResponseModel cached, CartResponseModel fresh) {
    if (cached.data.length != fresh.data.length) return false;

    for (var i = 0; i < cached.data.length; i++) {
      if (!cached.data[i].equals(fresh.data[i])) return false;
    }

    return cached.remaining == fresh.remaining;
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
            final quantity =
                dish.quantity ?? 1; // Get the quantity and default to 1 if null

            final calories =
                double.tryParse(dish.nutritionInfo.calories.value) ?? 0;
            final protein =
                double.tryParse(dish.nutritionInfo.protein.value) ?? 0;
            final carbs = double.tryParse(dish.nutritionInfo.carbs.value) ?? 0;
            final fat = double.tryParse(dish.nutritionInfo.totalFat.value) ?? 0;

            // Multiply by both servingSize and quantity
            totalCalories += calories * servingSize * quantity;
            totalProtein += protein * servingSize * quantity;
            totalCarbs += carbs * servingSize * quantity;
            totalFat += fat * servingSize * quantity;
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
    } catch (e) {
      return {
        'calories': 0.0,
        'protein': 0.0,
        'carbs': 0.0,
        'fat': 0.0,
      };
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _onUpdateQuantity(
      UpdateQuantity event, Emitter<GetCartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      // Optimistically update UI first
      final updatedCarts = _updateCartsWithNewQuantity(
        currentState.carts,
        event.cartId,
        event.dishId,
        event.quantity,
      );

      final totalNutrition = _calculateTotalNutrition(updatedCarts);

      // Emit new state immediately for responsive UI
      final updatedCartResponse = CartResponseModel(
        success: currentState.cartResponse.success,
        message: currentState.cartResponse.message,
        data: updatedCarts,
        remaining: currentState.remaining,
      );

      emit(CartLoaded(
        carts: updatedCarts,
        totalNutrition: totalNutrition,
        cartResponse: updatedCartResponse,
        remaining: currentState.remaining,
      ));

      // Add to pending updates
      _addToPendingUpdates(event.cartId, event.dishId, event.quantity);

      // Debounce API calls
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _syncPendingUpdates();
      });
    }
  }

  List<CartModel> _updateCartsWithNewQuantity(
    List<CartModel> carts,
    String cartId,
    String dishId,
    int quantity,
  ) {
    return carts.map((cart) {
      if (cart.cartId == cartId) {
        final updatedDishDetails = cart.dishDetails.map((dish) {
          if (dish.dishId == dishId) {
            return DishDetail(
              quantity: quantity,
              url: dish.url,
              restaurantId: dish.restaurantId,
              restaurantName: dish.restaurantName,
              categoryName: dish.categoryName,
              subCategoryName: dish.subCategoryName,
              dishId: dish.dishId,
              dishName: dish.dishName,
              servingSize: dish.servingSize,
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
  }

  void _addToPendingUpdates(String cartId, String dishId, int quantity) {
    if (!_pendingUpdates.containsKey(cartId)) {
      _pendingUpdates[cartId] = [];
    }

    // Find the dish in the current state to get its serving size
    final currentState = state as CartLoaded;
    final cart = currentState.carts.firstWhere((c) => c.cartId == cartId);
    final dish = cart.dishDetails.firstWhere((d) => d.dishId == dishId);

    _pendingUpdates[cartId]!.removeWhere((update) => update.dishId == dishId);
    _pendingUpdates[cartId]!.add(PendingUpdate(
      dishId: dishId,
      servingSize: dish.servingSize,
      quantity: quantity,
    ));
  }

  Future<void> _syncPendingUpdates() async {
    print('.........Syncing pending updates');
    bool anyUpdateSuccessful = false;

    for (final entry in _pendingUpdates.entries) {
      final cartId = entry.key;
      final updates = entry.value;

      if (updates.isEmpty) continue;

      final items = updates
          .map((update) => {
                'dishId': update.dishId,
                'servingSize': update.servingSize,
                'quantity': update.quantity,
              })
          .toList();

      final success = await cartRepository.updateQuantity(
        cartId: cartId,
        items: items,
      );
      print({"success": success});

      if (success) {
        anyUpdateSuccessful = true;
      } else {
        // If update fails, break the loop and reload cart
        add(LoadCart());
        break;
      }
    }

    // Clear pending updates after sync attempt
    _pendingUpdates.clear();

    // If any update was successful, reload the cart to get fresh data
    if (anyUpdateSuccessful) {
      // Clear cached data to force a fresh load
      _cachedCart = null;
      // Reload cart data
      add(LoadCart());
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
}

class PendingUpdate {
  final String dishId;
  final String servingSize;
  final int quantity;

  PendingUpdate({
    required this.dishId,
    required this.servingSize,
    required this.quantity,
  });
}
