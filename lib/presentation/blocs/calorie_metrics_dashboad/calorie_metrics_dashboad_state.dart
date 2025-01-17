import 'package:hungrx_app/data/Models/dashboad_screen/calorie_metrics_dialog.dart';

abstract class CalorieMetricsState {}

class CalorieMetricsInitial extends CalorieMetricsState {}

class CalorieMetricsLoading extends CalorieMetricsState {}

class CalorieMetricsLoaded extends CalorieMetricsState {
  final CalorieMetricsModel metrics;
  CalorieMetricsLoaded(this.metrics);
}

class CalorieMetricsError extends CalorieMetricsState {
  final String message;
  CalorieMetricsError(this.message);
}