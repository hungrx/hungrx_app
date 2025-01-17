import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_calorie_metrics_usecase.dart';
import 'package:hungrx_app/presentation/blocs/calorie_metrics_dashboad/calorie_metrics_dashboad_event.dart';
import 'package:hungrx_app/presentation/blocs/calorie_metrics_dashboad/calorie_metrics_dashboad_state.dart';

class CalorieMetricsBloc extends Bloc<CalorieMetricsEvent, CalorieMetricsState> {
  final GetCalorieMetricsUseCase _useCase;
  final AuthService _authService; // Add AuthService

  CalorieMetricsBloc(
    this._useCase,
    this._authService, // Inject AuthService
  ) : super(CalorieMetricsInitial()) {
    on<FetchCalorieMetrics>(_onFetchCalorieMetrics);
  }

  Future<void> _onFetchCalorieMetrics(
    FetchCalorieMetrics event,
    Emitter<CalorieMetricsState> emit,
  ) async {
    emit(CalorieMetricsLoading());
    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(CalorieMetricsError('User not logged in'));
        return;
      }

      final metrics = await _useCase.execute(userId);
      emit(CalorieMetricsLoaded(metrics));
    } catch (e) {
      emit(CalorieMetricsError(e.toString()));
    }
  }
}