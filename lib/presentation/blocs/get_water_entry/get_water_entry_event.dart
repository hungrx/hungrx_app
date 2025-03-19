abstract class GetWaterIntakeEvent {}

// Remove userId from FetchWaterIntakeData event
class FetchWaterIntakeData extends GetWaterIntakeEvent {
  final String date;

  FetchWaterIntakeData({required this.date}); // Removed userId parameter
}
class LoadCachedWaterIntake extends GetWaterIntakeEvent {
  final String date;
  LoadCachedWaterIntake({required this.date});
}