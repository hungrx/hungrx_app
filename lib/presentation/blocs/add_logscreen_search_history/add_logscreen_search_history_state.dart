import 'package:hungrx_app/data/Models/home_meals_screen/logmeal_search_history_model.dart';

abstract class LogMealSearchHistoryState {}

class LogMealSearchHistoryInitial extends LogMealSearchHistoryState {}

class LogMealSearchHistoryLoading extends LogMealSearchHistoryState {}

class LogMealSearchHistorySuccess extends LogMealSearchHistoryState {
  final LogMealSearchHistoryModel history;

  LogMealSearchHistorySuccess(this.history);
}

class LogMealSearchHistoryError extends LogMealSearchHistoryState {
  final String message;

  LogMealSearchHistoryError(this.message);
}