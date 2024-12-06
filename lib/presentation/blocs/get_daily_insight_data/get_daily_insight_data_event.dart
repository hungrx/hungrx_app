abstract class DailyInsightEvent {}

class GetDailyInsightData extends DailyInsightEvent {
  final String userId;
  final String date;

  GetDailyInsightData({
    required this.userId,
    required this.date,
  });
}
