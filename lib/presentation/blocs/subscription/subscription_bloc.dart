import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/subcription_model/store_subscription.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/subscrition_screen.dart/store_purchase_usecase.dart';
import 'package:hungrx_app/domain/usecases/subscrition_screen.dart/subscriptiion_usecase.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionUseCase _subscriptionUseCase;
  final StorePurchaseUseCase _storePurchaseUseCase;
  final AuthService _authService;

  SubscriptionBloc(
      this._subscriptionUseCase, this._storePurchaseUseCase, this._authService)
      : super(SubscriptionInitial()) {
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
      final subscriptions = await _subscriptionUseCase.getSubscriptions();
      final isPremium = await _subscriptionUseCase.isPremiumUser();
      // print("Loaded ${subscriptions.length} subscriptions during initialization");
      emit(SubscriptionsLoaded(subscriptions, isPremium: isPremium));
    } catch (e) {
      emit(SubscriptionError('Failed to initialize subscription service: $e'));
    }
  }

  Future<void> _onLoadSubscriptions(
    LoadSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    // print("Loading subscriptions...");
    emit(SubscriptionLoading());
    try {
      final subscriptions = await _subscriptionUseCase.getSubscriptions();
      //  print("Loaded ${subscriptions.length} subscriptions in BLoC");
      emit(SubscriptionsLoaded(subscriptions));
    } catch (e) {
      //  print("Error loading subscriptions: $e");
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
      final result =
          await _subscriptionUseCase.purchaseSubscription(event.subscription);
      final userId = await _authService.getUserId();
      // Check if purchase was successful using the 'success' key
      if (result['success'] == true) {
        // You can store transaction details here if needed
        final transactionDetails = {
          'userId': userId ?? '',
          'rcAppUserId': result['rcAppUserId'] ?? '',
          'productId': result['productId'] ?? '',
          'purchaseToken': result['purchaseToken'] ?? '',
          'transactionId': result['transactionId'] ?? '',
          'offerType': result['offerType'] ?? '',
          'priceInLocalCurrency': result['priceInLocalCurrency'] ?? '',
          'currencyCode': result['currencyCode'] ?? ''
        };
        // Log transaction details for debugging
        print('Transaction details: $transactionDetails');
        final purchaseDetailsModel =
            StorePurchaseDetailsModel.fromMap(transactionDetails);
        final storeResponse =
            await _storePurchaseUseCase.execute(purchaseDetailsModel);

        // Here you would call your API with the transaction details
        // await yourApiService.verifyPurchase(transactionDetails);

        if (storeResponse.success) {
          emit(SubscriptionPurchased(
              isSubscribed: storeResponse.isSubscribed,
              subscriptionLevel: storeResponse.subscriptionLevel));
        } else {
          emit(SubscriptionError(
              'Purchase completed but failed to store details: ${storeResponse.message}'));
        }
      } else {
        emit(SubscriptionError(
            result['error'] ?? 'Purchase could not be completed'));
      }
    } catch (e) {
      // Error handling remains the same
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
        emit(SubscriptionPurchased(
            isSubscribed: true, subscriptionLevel: 'restored'));
      } else {
        emit(const SubscriptionError('No purchases to restore'));
      }
    } catch (e) {
      emit(SubscriptionError('Failed to restore purchases: $e'));
    }
  }
}
