abstract class StreakEvent {}

class FetchStreakData extends StreakEvent {
  final String userId;
  FetchStreakData(this.userId);
}