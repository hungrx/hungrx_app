abstract class WeightUpdateState {}

class WeightUpdateInitial extends WeightUpdateState {}

class WeightUpdateLoading extends WeightUpdateState {}

class WeightUpdateSuccess extends WeightUpdateState {
  final String message;

  WeightUpdateSuccess(this.message);
}

class WeightUpdateError extends WeightUpdateState {
  final String error;

  WeightUpdateError(this.error);
}