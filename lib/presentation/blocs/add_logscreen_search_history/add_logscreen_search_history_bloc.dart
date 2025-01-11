import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/add_logmeal_search_history_usecase.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_event.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_state.dart';

class LogMealSearchHistoryBloc extends Bloc<LogMealSearchHistoryEvent, LogMealSearchHistoryState> {
  final AddLogMealSearchHistoryUseCase _useCase;
  final AuthService _authService;

  LogMealSearchHistoryBloc(
    this._useCase,
    this._authService,
  ) : super(LogMealSearchHistoryInitial()) {
    on<AddToLogMealSearchHistory>(_onAddToHistory);
  }

  Future<void> _onAddToHistory(
    AddToLogMealSearchHistory event,
    Emitter<LogMealSearchHistoryState> emit,
  ) async {
    emit(LogMealSearchHistoryLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(LogMealSearchHistoryError('User not logged in'));
        return;
      }

      final history = await _useCase.execute(
        userId: userId,
        productId: event.productId,
      );
      emit(LogMealSearchHistorySuccess(history));
    } catch (e) {
      print(e);
      emit(LogMealSearchHistoryError(e.toString()));
    }
  }
}
