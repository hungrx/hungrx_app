// lib/presentation/blocs/subscription/subscription_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/subscrition_screen.dart/subscriptiion_usecase.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionUseCase _subscriptionUseCase;

  SubscriptionBloc(this._subscriptionUseCase) : super(SubscriptionInitial()) {
    on<InitializeSubscriptionService>(_onInitializeSubscriptionService);
    on<LoadSubscriptions>(_onLoadSubscriptions);
    on<PurchaseSubscription>(_onPurchaseSubscription);
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<RestorePurchases>(_onRestorePurchases);
  }

 Future<void> _onInitializeSubscriptionService(
  InitializeSubscriptionService event,
  Emitter<SubscriptionState> emit,
) async {
  emit(SubscriptionLoading());
  try {
    await _subscriptionUseCase.initialize();
    
    // Instead of emitting SubscriptionInitialized, load subscriptions immediately
    final subscriptions = await _subscriptionUseCase.getSubscriptions();
    print("Loaded ${subscriptions.length} subscriptions during initialization");
    emit(SubscriptionsLoaded(subscriptions));
  } catch (e) {
    emit(SubscriptionError('Failed to initialize subscription service: $e'));
  }
}

  Future<void> _onLoadSubscriptions(
    LoadSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    print("Loading subscriptions...");
    emit(SubscriptionLoading());
    try {
      final subscriptions = await _subscriptionUseCase.getSubscriptions();
       print("Loaded ${subscriptions.length} subscriptions in BLoC");
      emit(SubscriptionsLoaded(subscriptions));
    } catch (e) {
       print("Error loading subscriptions: $e");
      emit(SubscriptionError('Failed to load subscriptions: $e'));
    }
  }

// In your SubscriptionBloc's purchase method
Future<void> _onPurchaseSubscription(
  PurchaseSubscription event,
  Emitter<SubscriptionState> emit,
) async {
  emit(SubscriptionLoading());
  try {
    final success = await _subscriptionUseCase.purchaseSubscription(event.subscription);
    if (success) {
      emit(SubscriptionPurchased());
    } else {
      emit(const SubscriptionError('Purchase could not be completed'));
    }
  } catch (e) {
    print('Purchase error: $e');
    
    // Handle common RevenueCat error cases
    String errorMessage;
    if (e.toString().contains('PURCHASE_CANCELLED')) {
      errorMessage = 'Purchase cancelled';
    } else if (e.toString().contains('PRODUCT_NOT_FOUND')) {
      errorMessage = 'Product not available';
    } else if (e.toString().contains('INSUFFICIENT_PERMISSIONS')) {
      errorMessage = 'Purchase not authorized';
    } else if (e.toString().contains('NETWORK_ERROR')) {
      errorMessage = 'Network error. Please check your connection';
    } else if (e.toString().contains('INVALID_RECEIPT')) {
      errorMessage = 'Payment verification failed';
    } else {
      errorMessage = 'Error during purchase. Please try again later.';
    }
    
    emit(SubscriptionError(errorMessage));
  }
}

  Future<void> _onCheckPremiumStatus(
    CheckPremiumStatus event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      final isPremium = await _subscriptionUseCase.isPremiumUser();
      emit(PremiumStatusChecked(isPremium));
    } catch (e) {
      emit(SubscriptionError('Failed to check premium status: $e'));
    }
  }
  Future<void> _onRestorePurchases(
  RestorePurchases event,
  Emitter<SubscriptionState> emit,
) async {
  emit(SubscriptionLoading());
  try {
    final success = await _subscriptionUseCase.restorePurchases();
    if (success) {
      emit(SubscriptionPurchased());
    } else {
      emit(const SubscriptionError('No purchases to restore'));
    }
  } catch (e) {
    emit(SubscriptionError('Failed to restore purchases: $e'));
  }
}

}
