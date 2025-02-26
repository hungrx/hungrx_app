// lib/presentation/blocs/subscription/subscription_event.dart
import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/subcription_model/subscription_model.dart';
abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSubscriptionService extends SubscriptionEvent {}

class LoadSubscriptions extends SubscriptionEvent {}

class PurchaseSubscription extends SubscriptionEvent {
  final SubscriptionModel subscription;

  const PurchaseSubscription(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class CheckPremiumStatus extends SubscriptionEvent {}
class RestorePurchases extends SubscriptionEvent {}
class DebugSubscriptions extends SubscriptionEvent {}
