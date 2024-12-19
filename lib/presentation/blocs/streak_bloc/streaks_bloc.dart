import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_streak_usecase.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final GetStreakUseCase _getStreakUseCase;

  StreakBloc(this._getStreakUseCase) : super(StreakInitial()) {
    on<FetchStreakData>(_onFetchStreakData);
  }

  Future<void> _onFetchStreakData(
    FetchStreakData event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());
    try {
      final streakData = await _getStreakUseCase.execute(event.userId);
      emit(StreakLoaded(streakData));
    } catch (e) {
      emit(StreakError(e.toString()));
    }
  }
}