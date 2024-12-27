import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/restaurant_menu_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_event.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';

class RestaurantMenuBloc extends Bloc<RestaurantMenuEvent, RestaurantMenuState> {
  final RestaurantMenuRepository repository;
  final AuthService _authService;

  RestaurantMenuBloc({
    required this.repository,
    required AuthService authService,
  })  : _authService = authService,
        super(RestaurantMenuInitial()) {
    on<LoadRestaurantMenu>(_onLoadRestaurantMenu);
  }

  Future<void> _onLoadRestaurantMenu(
    LoadRestaurantMenu event,
    Emitter<RestaurantMenuState> emit,
  ) async {
    emit(RestaurantMenuLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(RestaurantMenuError('User not logged in'));
        return;
      }

      final menuResponse = await repository.getMenu(
        event.restaurantId,
        userId,
      );
      emit(RestaurantMenuLoaded(menuResponse));
    } catch (e) {
      emit(RestaurantMenuError(e.toString()));
    }
  }
}
