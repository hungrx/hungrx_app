abstract class DailyInsightEvent {}

class GetDailyInsightData extends DailyInsightEvent {
  final String date;

  GetDailyInsightData({
    required this.date,
  });
}