abstract class GoalSettingsEvent {}

class FetchGoalSettings extends GoalSettingsEvent {
  // Removed userId parameter since it will be fetched from AuthService
  FetchGoalSettings();
}