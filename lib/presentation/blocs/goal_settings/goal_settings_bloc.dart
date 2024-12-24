import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_setting_screen/get_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_state.dart';

class GoalSettingsBloc extends Bloc<GoalSettingsEvent, GoalSettingsState> {
  final GetGoalSettingsUseCase _getGoalSettingsUseCase;
  final AuthService _authService;

  GoalSettingsBloc(
    this._getGoalSettingsUseCase,
    this._authService,
  ) : super(GoalSettingsInitial()) {
    on<FetchGoalSettings>(_onFetchGoalSettings);
  }

  Future<void> _onFetchGoalSettings(
    FetchGoalSettings event,
    Emitter<GoalSettingsState> emit,
  ) async {
    emit(GoalSettingsLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(GoalSettingsError('User not logged in'));
        return;
      }

      final settings = await _getGoalSettingsUseCase.execute(userId);
      emit(GoalSettingsLoaded(settings));
    } catch (e) {
      emit(GoalSettingsError(e.toString()));
    }
  }
}