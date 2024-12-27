import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/restaurant_menu.dart/add_to_cart_usecase.dart';
import 'package:hungrx_app/presentation/blocs/add_food_kart/food_kart_event.dart';
import 'package:hungrx_app/presentation/blocs/add_food_kart/food_kart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase _addToCartUseCase;

  CartBloc(this._addToCartUseCase) : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final response = await _addToCartUseCase.execute(event.item);
      emit(CartSuccess(response));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}