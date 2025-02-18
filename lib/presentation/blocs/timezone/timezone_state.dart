import 'package:hungrx_app/data/Models/timezone/timezone_model.dart';

abstract class TimezoneState {}

class TimezoneInitial extends TimezoneState {}

class TimezoneUpdating extends TimezoneState {}

class TimezoneUpdateSuccess extends TimezoneState {
  final TimezoneModel timezone;
  TimezoneUpdateSuccess(this.timezone);
}

class TimezoneUpdateFailure extends TimezoneState {
  final String error;
  TimezoneUpdateFailure(this.error);
}