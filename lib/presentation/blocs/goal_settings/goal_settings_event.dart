abstract class GoalSettingsEvent {}

class FetchGoalSettings extends GoalSettingsEvent {
  final String userId;
  FetchGoalSettings(this.userId);
}
