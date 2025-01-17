// Modified Event classes
abstract class WeightHistoryEvent {}

// Remove userId from FetchWeightHistory event
class FetchWeightHistory extends WeightHistoryEvent {
  FetchWeightHistory(); // No longer needs userId parameter
}