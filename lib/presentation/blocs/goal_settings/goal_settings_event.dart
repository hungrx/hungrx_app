abstract class GoalSettingsEvent {}

class FetchGoalSettings extends GoalSettingsEvent {
  // Removed userId parameter since it will be fetched from AuthService
  FetchGoalSettings();
}
class ClearGoalSettings extends GoalSettingsEvent {}

class LoadCachedGoalSettings extends GoalSettingsEvent {
  LoadCachedGoalSettings();
}