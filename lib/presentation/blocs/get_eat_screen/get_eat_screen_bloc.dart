import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/get_eat_screen_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_state.dart';

class EatScreenBloc extends Bloc<EatScreenEvent, EatScreenState> {
  final GetEatScreenUseCase _useCase;
  final AuthService _authService;

  EatScreenBloc(this._useCase, this._authService) : super(EatScreenInitial()) {
    on<GetEatScreenDataEvent>(_onGetEatScreenData);
  }

  Future<void> _onGetEatScreenData(
    GetEatScreenDataEvent event,
    Emitter<EatScreenState> emit,
  ) async {
    try {
      emit(EatScreenLoading());
      
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(EatScreenError('User not logged in'));
        return;
      }
      
      final result = await _useCase.execute(userId);
      emit(EatScreenLoaded(result));
    } catch (e) {
      emit(EatScreenError(e.toString()));
    }
  }
}