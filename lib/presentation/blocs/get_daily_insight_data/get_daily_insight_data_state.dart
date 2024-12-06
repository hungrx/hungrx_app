import 'package:hungrx_app/data/Models/daily_food_response.dart';

abstract class DailyInsightState {}

class DailyInsightInitial extends DailyInsightState {}

class DailyInsightLoading extends DailyInsightState {}

class DailyInsightLoaded extends DailyInsightState {
  final DailyFoodResponse data;

  DailyInsightLoaded(this.data);
}

class DailyInsightError extends DailyInsightState {
  final String message;

  DailyInsightError(this.message);
}