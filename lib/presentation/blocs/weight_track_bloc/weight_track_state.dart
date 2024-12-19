import 'package:hungrx_app/data/Models/weight_screen/weight_history_model.dart';

abstract class WeightHistoryState {}

class WeightHistoryInitial extends WeightHistoryState {}

class WeightHistoryLoading extends WeightHistoryState {}

class WeightHistoryLoaded extends WeightHistoryState {
  final WeightHistoryModel weightHistory;
  WeightHistoryLoaded(this.weightHistory);
}

class WeightHistoryNoRecords extends WeightHistoryState {}

class WeightHistoryError extends WeightHistoryState {
  final String message;
  WeightHistoryError(this.message);
}