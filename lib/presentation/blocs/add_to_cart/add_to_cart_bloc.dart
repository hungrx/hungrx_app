import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/restaurant_menu.dart/add_to_cart_usecase.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_event.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_state.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  final AddToCartUseCase _addToCartUseCase;
  final AuthService _authService;

  AddToCartBloc(
    this._addToCartUseCase,
    this._authService,
  ) : super(AddToCartInitial()) {
    on<SubmitAddToCartEvent>(_onAddToCart);
  }

  Future<void> _onAddToCart(SubmitAddToCartEvent event, Emitter<AddToCartState> emit) async {
    emit(AddToCartLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(AddToCartError('User not logged in'));
        return;
      }

      // Create the complete cart request with userId
      final completeRequest = await event.request.copyWithUserId(userId);
      final response = await _addToCartUseCase.execute(completeRequest);
      emit(AddToCartSuccess(response));
    } catch (e) {
      emit(AddToCartError(e.toString()));
    }
  }
}