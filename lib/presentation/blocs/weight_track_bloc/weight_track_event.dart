abstract class WeightHistoryEvent {}

class FetchWeightHistory extends WeightHistoryEvent {
  final String userId;
  
  FetchWeightHistory(this.userId);
}