import 'package:equatable/equatable.dart';

abstract class WaterIntakeEvent extends Equatable {
  const WaterIntakeEvent();

  @override
  List<Object?> get props => [];
}

// Remove userId from AddWaterIntake event
class AddWaterIntake extends WaterIntakeEvent {
  final String amount;

  const AddWaterIntake({
    required this.amount,
  });

  @override
  List<Object?> get props => [amount];
}