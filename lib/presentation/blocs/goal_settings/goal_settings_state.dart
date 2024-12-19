import 'package:hungrx_app/data/Models/profile_setting_screen/goal_settings_model.dart';

abstract class GoalSettingsState {}

class GoalSettingsInitial extends GoalSettingsState {}

class GoalSettingsLoading extends GoalSettingsState {}

class GoalSettingsLoaded extends GoalSettingsState {
  final GoalSettingsModel settings;
  GoalSettingsLoaded(this.settings);
}

class GoalSettingsError extends GoalSettingsState {
  final String message;
  GoalSettingsError(this.message);
}