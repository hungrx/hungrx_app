import 'package:hungrx_app/data/Models/water_screen/delete_water_response.dart';

abstract class DeleteWaterState {}

class DeleteWaterIntakeInitial extends DeleteWaterState {}

class DeleteWaterIntakeLoading extends DeleteWaterState {}

class DeleteWaterIntakeSuccess extends DeleteWaterState {
  final String message;
  final DeleteWaterData data;

  DeleteWaterIntakeSuccess({required this.message, required this.data});
}

class DeleteWaterIntakeError extends DeleteWaterState {
  final String message;

  DeleteWaterIntakeError({required this.message});
}