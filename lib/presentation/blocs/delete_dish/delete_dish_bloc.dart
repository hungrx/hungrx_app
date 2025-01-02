import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/delete_dish_cart_request.dart';
import 'package:hungrx_app/domain/usecases/cart_screen.dart/delete_dish_cart_usecase.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_state.dart';

class DeleteDishCartBloc extends Bloc<DeleteDishCartEvent, DeleteDishCartState> {
  final DeleteDishCartUseCase _useCase;

  DeleteDishCartBloc(this._useCase) : super(DeleteDishCartInitial()) {
    on<DeleteDishFromCart>(_handleDeleteDishFromCart);
  }

  Future<void> _handleDeleteDishFromCart(
    DeleteDishFromCart event,
    Emitter<DeleteDishCartState> emit,
  ) async {
    emit(DeleteDishCartLoading());
    try {
      final request = DeleteDishCartRequest(
        cartId: event.cartId,
        restaurantId: event.restaurantId,
        dishId: event.dishId,
      );

      final response = await _useCase.execute(request);
      if (response.status) {
        emit(DeleteDishCartSuccess(response.message));
      } else {
        emit(DeleteDishCartError(response.message));
      }
    } catch (e) {
      emit(DeleteDishCartError(e.toString()));
    }
  }
}