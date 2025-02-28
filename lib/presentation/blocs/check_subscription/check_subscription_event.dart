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

  const UpdateSubscriptionStatus({
    required this.isSubscribed,
    required this.subscriptionLevel,
  });

  @override
  List<Object?> get props => [isSubscribed, subscriptionLevel];
}