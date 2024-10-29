import 'package:hungrx_app/data/Models/streak_data_model.dart';

abstract class StreakState {}

class StreakInitial extends StreakState {}

class StreakLoading extends StreakState {}

class StreakLoaded extends StreakState {
  final StreakDataModel streakData;
  StreakLoaded(this.streakData);
}

class StreakError extends StreakState {
  final String message;
  StreakError(this.message);
}