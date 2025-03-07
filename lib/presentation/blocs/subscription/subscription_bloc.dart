import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/subcription_model/store_subscription.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';
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
    on<UpdateSubscriptionInfo>(_onUpdateSubscriptionInfo); // New event
  }

  Future<void> _onUpdateSubscriptionInfo(
    UpdateSubscriptionInfo event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      // Call the RevenueCat API to get updated subscription info.
      final updatedInfo = await PurchaseService.getSubscriptionInfo();
      final userId = await _authService.getUserId();
      // Build a map of transaction details using the updated information.

      final transactionDetails = {
        'rcAppUserId': updatedInfo.rcAppUserId ?? '',
        'userId': userId ?? '',
        'productId': updatedInfo.productId ?? '',
        'isUpdate': true, // Added isUpdate field set to false
        'subscriptionLevel':
            updatedInfo.offerType ?? 'monthly', // Adjust as needed
        'expirationDate': updatedInfo.expirationDate ?? '',
        'revenuecatDetails': {
          'isCanceled': updatedInfo.isCanceled,
          'expirationDate': updatedInfo.expirationDate ?? '',
          'productIdentifier': updatedInfo.productIdentifier ?? '',
          'periodType': updatedInfo.periodType, // e.g., "normal"
          'latestPurchaseDate': updatedInfo.latestPurchaseDate ?? '',
          'originalPurchaseDate': updatedInfo.originalPurchaseDate ?? '',
          'store': updatedInfo.store, // e.g., "app_store" or "play_store"
          'isSandbox': updatedInfo.isSandbox,
          'willRenew': updatedInfo.willRenew,
        }
      };

      // Convert to your model and call the store purchase use case.
      final purchaseDetailsModel =
          StorePurchaseDetailsModel.fromMap(transactionDetails);
      final storeResponse =
          await _storePurchaseUseCase.execute(purchaseDetailsModel);

      if (storeResponse.success) {
        // Emit updated subscription state.
        emit(SubscriptionPurchased(
          isSubscribed: storeResponse.isSubscribed,
          subscriptionLevel: storeResponse.subscriptionLevel,
        ));
      } else {
        emit(SubscriptionError(
            'Subscription update completed but failed to store details: ${storeResponse.message}'));
      }
    } catch (e) {
      emit(SubscriptionError('Error updating subscription: ${e.toString()}'));
    }
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
      if (result.success) {
        // Create transaction details map with the new structure
        final transactionDetails = {
          'userId': userId ?? '',
          'rcAppUserId': result.rcAppUserId ?? '',
          'productId': result.productId ?? '',
          'isUpdate': false, // Added isUpdate field set to false
          'subscriptionLevel':
              result.offerType ?? 'monthly', // Add appropriate mapping
          'expirationDate': result.expirationDate ?? '',
          'revenuecatDetails': {
            'isCanceled': result.isCanceled,
            'expirationDate': result.expirationDate ?? '',
            'productIdentifier': result.productIdentifier ?? '',
            'periodType': 'normal', // Add appropriate mapping
            'latestPurchaseDate': result.latestPurchaseDate ?? '',
            'originalPurchaseDate': result.originalPurchaseDate ?? '',
            'store': result.store ?? 'app_store', // Add appropriate mapping
            'isSandbox': result.isSandbox,
            'willRenew': result.willRenew,
          }
        };

        // Log transaction details for debugging

        final purchaseDetailsModel =
            StorePurchaseDetailsModel.fromMap(transactionDetails);
        final storeResponse =
            await _storePurchaseUseCase.execute(purchaseDetailsModel);

        if (storeResponse.success) {
          emit(SubscriptionPurchased(
              isSubscribed: storeResponse.isSubscribed,
              subscriptionLevel: storeResponse.subscriptionLevel));
        } else {
          emit(SubscriptionError(
              'Purchase completed but failed to store details: ${storeResponse.message}'));
        }
      } else {
        // Handle purchase failure

        // Check for item already owned
        if (result.error?.toString().contains('6') == true ||
            result.error
                    ?.toString()
                    .contains('This product is already active') ==
                true ||
            result.error?.toString().contains('ITEM_ALREADY_OWNED') == true) {
          emit(SubscriptionError('GOOGLE_PLAY_ACCOUNT_MISMATCH'));
          return;
        }
        emit(SubscriptionError(
            result.error ?? 'Purchase could not be completed'));
      }
    } on PlatformException catch (e) {

      // Handle error code 6 and item already owned cases
      if (e.code == '6' ||
          e.message?.contains('This product is already active') == true ||
          e.message?.contains('ITEM_ALREADY_OWNED') == true) {
        emit(SubscriptionError('GOOGLE_PLAY_ACCOUNT_MISMATCH'));
        return;
      }

      String errorMessage = e.message ?? 'Unknown error occurred';
      emit(SubscriptionError(errorMessage));
    } catch (e) {
      String message = e.toString();

      if (message.contains('6') ||
          message.contains('This product is already active') ||
          message.contains('ITEM_ALREADY_OWNED')) {
        emit(SubscriptionError('GOOGLE_PLAY_ACCOUNT_MISMATCH'));
        return;
      }
      emit(SubscriptionError('Unexpected error: $message'));
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
