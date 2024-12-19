import 'package:hungrx_app/data/Models/profile_screen/update_goal_settings_model.dart';

abstract class UpdateGoalSettingsState {}

class UpdateGoalSettingsInitial extends UpdateGoalSettingsState {}

class UpdateGoalSettingsLoading extends UpdateGoalSettingsState {}

class UpdateGoalSettingsSuccess extends UpdateGoalSettingsState {
  final UpdateGoalSettingsModel settings;

  UpdateGoalSettingsSuccess({required this.settings});
}

class UpdateGoalSettingsFailure extends UpdateGoalSettingsState {
  final String error;

  UpdateGoalSettingsFailure({required this.error});
}
