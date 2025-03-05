import 'package:equatable/equatable.dart';

abstract class CheckStatusSubscriptionEvent extends Equatable {
  const CheckStatusSubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class CheckSubscription extends CheckStatusSubscriptionEvent {
  final String userId;

  const CheckSubscription(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateSubscriptionStatus extends CheckStatusSubscriptionEvent {
 final bool isSubscribed;
  final String subscriptionLevel;
  final bool isValid;
  final DateTime? expirationDate;

  const UpdateSubscriptionStatus({
   required this.isSubscribed,
    required this.subscriptionLevel,
    required this.isValid,
    this.expirationDate,
  });

  @override
  List<Object?> get props => [isSubscribed, subscriptionLevel, isValid, expirationDate];
}