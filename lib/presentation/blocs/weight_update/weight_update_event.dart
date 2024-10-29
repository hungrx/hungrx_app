abstract class WeightUpdateEvent {}

class UpdateWeightRequested extends WeightUpdateEvent {
  final double newWeight;

  UpdateWeightRequested(this.newWeight);
}