import 'package:hungrx_app/data/Models/update_goal_settings_model.dart';

abstract class UpdateGoalSettingsEvent {}

class UpdateGoalSettingsSubmitted extends UpdateGoalSettingsEvent {
  final UpdateGoalSettingsModel settings;

  UpdateGoalSettingsSubmitted({required this.settings});
}