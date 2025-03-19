abstract class DailyInsightEvent {}

class GetDailyInsightData extends DailyInsightEvent {
  final String date;

  GetDailyInsightData({
    required this.date,
  });
}
class LoadCachedDailyInsight extends DailyInsightEvent {
  final String date;

  LoadCachedDailyInsight({
    required this.date,
  });
}