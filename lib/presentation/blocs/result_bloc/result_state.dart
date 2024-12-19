import 'package:hungrx_app/data/Models/profile_setting_screen/tdee_result_model.dart';

abstract class TDEEState {}

class TDEEInitial extends TDEEState {}

class TDEELoading extends TDEEState {}

class TDEELoaded extends TDEEState {
  final TDEEResultModel result;

  TDEELoaded(this.result);
}

class TDEEError extends TDEEState {
  final String message;

  TDEEError(this.message);
}
