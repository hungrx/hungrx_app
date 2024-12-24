import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/daily_insight_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_event.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_state.dart';

class DailyInsightBloc extends Bloc<DailyInsightEvent, DailyInsightState> {
  final DailyInsightRepository repository;
  final AuthService authService;

  DailyInsightBloc(this.repository, this.authService) : super(DailyInsightInitial()) {
    on<GetDailyInsightData>(_onGetDailyInsightData);
  }

  Future<void> _onGetDailyInsightData(
    GetDailyInsightData event,
    Emitter<DailyInsightState> emit,
  ) async {
    emit(DailyInsightLoading());
    try {
      final userId = await authService.getUserId();
      if (userId == null) {
        emit(DailyInsightError('User not logged in'));
        return;
      }

      final data = await repository.getDailyInsightData(
        userId: userId,
        date: event.date,
      );
      emit(DailyInsightLoaded(data));
    } catch (e) {
      emit(DailyInsightError(e.toString()));
    }
  }
}