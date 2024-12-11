import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/update_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/update_goal_settings/update_goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/update_goal_settings/update_goal_settings_state.dart';

class UpdateGoalSettingsBloc extends Bloc<UpdateGoalSettingsEvent, UpdateGoalSettingsState> {
  final UpdateGoalSettingsUseCase _useCase;

  UpdateGoalSettingsBloc({required UpdateGoalSettingsUseCase useCase})
      : _useCase = useCase,
        super(UpdateGoalSettingsInitial()) {
    on<UpdateGoalSettingsSubmitted>(_onUpdateGoalSettingsSubmitted);
  }

  Future<void> _onUpdateGoalSettingsSubmitted(
    UpdateGoalSettingsSubmitted event,
    Emitter<UpdateGoalSettingsState> emit,
  ) async {
    emit(UpdateGoalSettingsLoading());
    try {
      final updatedSettings = await _useCase.execute(event.settings);
      emit(UpdateGoalSettingsSuccess(settings: updatedSettings));
    } catch (e) {
      emit(UpdateGoalSettingsFailure(error: e.toString()));
    }
  }
}
