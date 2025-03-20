abstract class StreakEvent {}

class FetchStreakData extends StreakEvent {
  // Removed userId parameter since it will be fetched from AuthService
  FetchStreakData();
}
class LoadCachedStreak extends StreakEvent {
  LoadCachedStreak();
}