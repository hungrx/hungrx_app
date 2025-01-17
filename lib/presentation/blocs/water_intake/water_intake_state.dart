import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/water_screen/add_water_response.dart';


abstract class WaterIntakeState extends Equatable {
  const WaterIntakeState();

  @override
  List<Object?> get props => [];
}

class WaterIntakeInitial extends WaterIntakeState {}

class WaterIntakeLoading extends WaterIntakeState {}

class WaterIntakeSuccess extends WaterIntakeState {
  final WaterIntakeData data;

  const WaterIntakeSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class WaterIntakeFailure extends WaterIntakeState {
  final String message;

  const WaterIntakeFailure(this.message);

  @override
  List<Object?> get props => [message];
}