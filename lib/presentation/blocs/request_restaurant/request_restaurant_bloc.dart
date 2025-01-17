import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/request_restaurant_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/request_restaurant_usecase.dart';
import 'package:hungrx_app/presentation/blocs/request_restaurant/request_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/request_restaurant/request_restaurant_state.dart';

class RequestRestaurantBloc
    extends Bloc<RequestRestaurantEvent, RequestRestaurantState> {
  final RequestRestaurantUseCase useCase;
  final AuthService _authService;

  RequestRestaurantBloc(
    this.useCase,
    this._authService,
  ) : super(RequestRestaurantInitial()) {
    on<SubmitRequestRestaurantEvent>(_onSubmitRequest);
  }

  Future<void> _onSubmitRequest(
    SubmitRequestRestaurantEvent event,
    Emitter<RequestRestaurantState> emit,
  ) async {
    emit(RequestRestaurantLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(RequestRestaurantFailure('User not logged in'));
        return;
      }

      final request = RequestRestaurantModel(
        userId: userId,
        restaurantName: event.restaurantName,
        restaurantType: event.restaurantType,
        area: event.area,
      );

      final result = await useCase.execute(request);
      if (result) {
        emit(RequestRestaurantSuccess());
      } else {
        emit(RequestRestaurantFailure('Request failed'));
      }
    } catch (e) {
      emit(RequestRestaurantFailure(e.toString()));
    }
  }
}