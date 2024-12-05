import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/add_logmeal_search_history_usecase.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_event.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_state.dart';

class LogMealSearchHistoryBloc extends Bloc<LogMealSearchHistoryEvent, LogMealSearchHistoryState> {
  final AddLogMealSearchHistoryUseCase _useCase;

  LogMealSearchHistoryBloc(this._useCase) : super(LogMealSearchHistoryInitial()) {
    on<AddToLogMealSearchHistory>(_onAddToHistory);
  }

  Future<void> _onAddToHistory(
    AddToLogMealSearchHistory event,
    Emitter<LogMealSearchHistoryState> emit,
  ) async {
    emit(LogMealSearchHistoryLoading());
    try {
      final history = await _useCase.execute(
        userId: event.userId,
        productId: event.productId,
      );
      emit(LogMealSearchHistorySuccess(history));
    } catch (e) {
      emit(LogMealSearchHistoryError(e.toString()));
    }
  }
}