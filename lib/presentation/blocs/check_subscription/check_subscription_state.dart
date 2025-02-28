import 'package:equatable/equatable.dart';

abstract class CheckStatusSubscriptionState extends Equatable {
  const CheckStatusSubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends CheckStatusSubscriptionState {}

class SubscriptionLoading extends CheckStatusSubscriptionState {}

class SubscriptionActive extends CheckStatusSubscriptionState {
  final String level;

  const SubscriptionActive(this.level);

  @override
  List<Object?> get props => [level];
}

class SubscriptionInactive extends CheckStatusSubscriptionState {}

class SubscriptionError extends CheckStatusSubscriptionState {
  final String error;

  const SubscriptionError(this.error);

  @override
  List<Object?> get props => [error];
}