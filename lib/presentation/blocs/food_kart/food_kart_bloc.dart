import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_event.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final updatedItems = List<CartItem>.from(state.items)..add(event.item);
    final newTotalCalories = state.totalCalories + event.item.nutritionInfo.calories;
    
    emit(state.copyWith(
      items: updatedItems,
      totalCalories: newTotalCalories,
    ));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}