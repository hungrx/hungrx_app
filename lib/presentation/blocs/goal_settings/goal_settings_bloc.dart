import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/get_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_state.dart';

class GoalSettingsBloc extends Bloc<GoalSettingsEvent, GoalSettingsState> {
  final GetGoalSettingsUseCase _getGoalSettingsUseCase;

  GoalSettingsBloc(this._getGoalSettingsUseCase) : super(GoalSettingsInitial()) {
    on<FetchGoalSettings>(_onFetchGoalSettings);
  }

  Future<void> _onFetchGoalSettings(
    FetchGoalSettings event,
    Emitter<GoalSettingsState> emit,
  ) async {
    emit(GoalSettingsLoading());
    try {
      final settings = await _getGoalSettingsUseCase.execute(event.userId);
      emit(GoalSettingsLoaded(settings));
    } catch (e) {
      emit(GoalSettingsError(e.toString()));
    }
  }
}