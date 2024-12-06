import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/daily_insight_repository.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_event.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_state.dart';

class DailyInsightBloc extends Bloc<DailyInsightEvent, DailyInsightState> {
  final DailyInsightRepository repository;

  DailyInsightBloc(this.repository) : super(DailyInsightInitial()) {
    on<GetDailyInsightData>(_onGetDailyInsightData);
  }

  Future<void> _onGetDailyInsightData(
    GetDailyInsightData event,
    Emitter<DailyInsightState> emit,
  ) async {
    emit(DailyInsightLoading());
    try {
      final data = await repository.getDailyInsightData(
        userId: event.userId,
        date: event.date,
      );
      emit(DailyInsightLoaded(data));
    } catch (e) {
      emit(DailyInsightError(e.toString()));
    }
  }
}