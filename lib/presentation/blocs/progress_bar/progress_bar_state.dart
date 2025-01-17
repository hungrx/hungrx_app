import 'package:hungrx_app/data/Models/progress_bar/progress_bar_model.dart';

abstract class ProgressBarState {}

class ProgressBarInitial extends ProgressBarState {}

class ProgressBarLoading extends ProgressBarState {}

class ProgressBarLoaded extends ProgressBarState {
  final ProgressBarModel data;
  ProgressBarLoaded(this.data);
}

class ProgressBarError extends ProgressBarState {
  final String message;
  ProgressBarError(this.message);
}