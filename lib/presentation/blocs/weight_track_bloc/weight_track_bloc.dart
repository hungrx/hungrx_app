import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_history_api.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/weight_screen/get_weight_history_usecase.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_state.dart';

class WeightHistoryBloc extends Bloc<WeightHistoryEvent, WeightHistoryState> {
  final GetWeightHistoryUseCase _getWeightHistoryUseCase;
  final AuthService _authService; // Add AuthService

  WeightHistoryBloc(
    this._getWeightHistoryUseCase,
    this._authService, // Inject AuthService
  ) : super(WeightHistoryInitial()) {
    on<FetchWeightHistory>(_onFetchWeightHistory);
  }

  Future<void> _onFetchWeightHistory(
    FetchWeightHistory event,
    Emitter<WeightHistoryState> emit,
  ) async {
    emit(WeightHistoryLoading());
    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(WeightHistoryError('User not logged in'));
        return;
      }

      final weightHistory = await _getWeightHistoryUseCase.execute(userId);
      emit(WeightHistoryLoaded(weightHistory));
    } catch (e) {
      if (e is NoWeightRecordsException) {
        emit(WeightHistoryNoRecords());
        emit(WeightHistoryError(e.toString()));
      } else {
        emit(WeightHistoryError(e.toString()));
      }
    }
  }
}

