import 'package:equatable/equatable.dart';

abstract class CheckStatusSubscriptionState extends Equatable {
  const CheckStatusSubscriptionState();

  @override
  List<Object?> get props => [];
}

class CheckSubscriptionInitial extends CheckStatusSubscriptionState {}

class CheckSubscriptionLoading extends CheckStatusSubscriptionState {}

class CheckSubscriptionActive extends CheckStatusSubscriptionState {
  final String level;
  final bool isValid;
  final DateTime? expirationDate;

  const CheckSubscriptionActive(
    this.level,
    this.isValid,
    this.expirationDate,
  );

  @override
  List<Object?> get props => [level, isValid, expirationDate];
}

class CheckSubscriptionInactive extends CheckStatusSubscriptionState {}

class CheckSubscriptionError extends CheckStatusSubscriptionState {
  final String error;

  const CheckSubscriptionError(this.error);

  @override
  List<Object?> get props => [error];
}
