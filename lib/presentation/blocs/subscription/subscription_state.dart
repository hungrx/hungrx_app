// lib/presentation/blocs/subscription/subscription_state.dart
import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionInitialized extends SubscriptionState {}

class SubscriptionsLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptions;
  final bool isPremium;

  const SubscriptionsLoaded(this.subscriptions, {this.isPremium = false});

  @override
  List<Object?> get props => [subscriptions, isPremium];
}


class SubscriptionPurchased extends SubscriptionState {
  final bool isSubscribed;
  final String subscriptionLevel;

  const SubscriptionPurchased({
    required this.isSubscribed,
    required this.subscriptionLevel,
  });
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

class PremiumStatusChecked extends SubscriptionState {
  final bool isPremium;

  const PremiumStatusChecked(this.isPremium);

  @override
  List<Object?> get props => [isPremium];
}