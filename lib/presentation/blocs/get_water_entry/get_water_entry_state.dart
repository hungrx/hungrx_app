

import 'package:hungrx_app/data/Models/water_screen/get_water_entry_model.dart';

abstract class GetWaterIntakeState {}

class GetWaterIntakeInitial extends GetWaterIntakeState {}

class GetWaterIntakeLoading extends GetWaterIntakeState {}

class GetWaterIntakeLoaded extends GetWaterIntakeState {
  final WaterIntakeData data;

  GetWaterIntakeLoaded(this.data);
}

class GetWaterIntakeError extends GetWaterIntakeState {
  final String message;

  GetWaterIntakeError(this.message);
}