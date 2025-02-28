import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_state.dart';

class CheckStatusSubscriptionBloc extends Bloc<CheckStatusSubscriptionEvent, CheckStatusSubscriptionState> {
  final AuthService _authService;

  CheckStatusSubscriptionBloc({required AuthService authService})
      : _authService = authService,
        super(SubscriptionInitial()) {
    on<CheckSubscription>(_onCheckSubscription);
    on<UpdateSubscriptionStatus>(_onUpdateSubscriptionStatus);
  }

  Future<void> _onCheckSubscription(
    CheckSubscription event,
    Emitter<CheckStatusSubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final subscriptionData = await _authService.checkSubscriptionStatus(event.userId);
      
      if (subscriptionData != null) {
        if (subscriptionData['isSubscribed']) {
          emit(SubscriptionActive(subscriptionData['subscriptionLevel']));
        } else {
          emit(SubscriptionInactive());
        }
      } else {
        emit(const SubscriptionError('Failed to fetch subscription status'));
      }
    } catch (e) {
      emit(SubscriptionError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSubscriptionStatus(
    UpdateSubscriptionStatus event,
    Emitter<CheckStatusSubscriptionState> emit,
  ) async {
    if (event.isSubscribed) {
      emit(SubscriptionActive(event.subscriptionLevel));
    } else {
      emit(SubscriptionInactive());
    }
  }
}