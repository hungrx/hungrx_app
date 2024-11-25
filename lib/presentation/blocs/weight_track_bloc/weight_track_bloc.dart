import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/datasources/api/weight_history_api.dart';
import 'package:hungrx_app/domain/usecases/get_weight_history_usecase.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_state.dart';

class WeightHistoryBloc extends Bloc<WeightHistoryEvent, WeightHistoryState> {
  final GetWeightHistoryUseCase _getWeightHistoryUseCase;

  WeightHistoryBloc(this._getWeightHistoryUseCase)
      : super(WeightHistoryInitial()) {
    on<FetchWeightHistory>(_onFetchWeightHistory);
  }

  Future<void> _onFetchWeightHistory(
    FetchWeightHistory event,
    Emitter<WeightHistoryState> emit,
  ) async {
    emit(WeightHistoryLoading());
    try {
      final weightHistory =
          await _getWeightHistoryUseCase.execute(event.userId);
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
