import 'package:bloc/bloc.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/cart_screen.dart/consume_cart_usecase.dart';
import 'package:hungrx_app/presentation/blocs/consume_cart/consume_cart_event.dart';
import 'package:hungrx_app/presentation/blocs/consume_cart/consume_cart_state.dart';

class ConsumeCartBloc extends Bloc<ConsumeCartEvent, ConsumeCartState> {
  final ConsumeCartUseCase _useCase;
  final AuthService _authService;

  ConsumeCartBloc(
    this._useCase,
    this._authService,
  ) : super(ConsumeCartInitial()) {
    on<ConsumeCartSubmitted>(_onConsumeCartSubmitted);
  }

  Future<void> _onConsumeCartSubmitted(
    ConsumeCartSubmitted event,
    Emitter<ConsumeCartState> emit,
  ) async {
    emit(ConsumeCartLoading());

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(ConsumeCartError('User not logged in'));
        return;
      }

      final request = ConsumeCartRequest(
        userId: userId,
        mealType: event.mealType,
        orderDetails: event.orderDetails,
      );

      final response = await _useCase.execute(request);
      emit(ConsumeCartSuccess(response));
    } catch (e) {
      emit(ConsumeCartError(e.toString()));
    }
  }
}