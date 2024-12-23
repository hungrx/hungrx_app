import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_streak_usecase.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final GetStreakUseCase _getStreakUseCase;
  final AuthService _authService;

  StreakBloc(this._getStreakUseCase, this._authService) : super(StreakInitial()) {
    on<FetchStreakData>(_onFetchStreakData);
  }

  Future<void> _onFetchStreakData(
    FetchStreakData event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(StreakError('User not logged in'));
        return;
      }
      
      final streakData = await _getStreakUseCase.execute(userId);
      emit(StreakLoaded(streakData));
    } catch (e) {
      emit(StreakError(e.toString()));
    }
  }
}