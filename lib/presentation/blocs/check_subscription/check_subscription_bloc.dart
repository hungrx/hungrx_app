import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/verify_subscription/verify_subscription_usecase.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_state.dart';

class CheckStatusSubscriptionBloc
    extends Bloc<CheckStatusSubscriptionEvent, CheckStatusSubscriptionState> {
  final VerifySubscriptionUseCase _verifySubscriptionUseCase;

  CheckStatusSubscriptionBloc({
    required VerifySubscriptionUseCase verifySubscriptionUseCase,
  })  : _verifySubscriptionUseCase = verifySubscriptionUseCase,
        super(CheckSubscriptionInitial()) {
    on<CheckSubscription>(_onCheckSubscription);
    on<UpdateSubscriptionStatus>(_onUpdateSubscriptionStatus);
  }

  Future<void> _onCheckSubscription(
    CheckSubscription event,
    Emitter<CheckStatusSubscriptionState> emit,
  ) async {
    emit(CheckSubscriptionLoading());
    try {
      final subscriptionData =
          await _verifySubscriptionUseCase.execute(event.userId);

      // Instead of checking only if the user is subscribed,
      // we now check if the subscription is valid (i.e. still active until expiration)
      if (subscriptionData.isValid) {
        emit(CheckSubscriptionActive(
          subscriptionData.subscriptionLevel,
          subscriptionData.isValid,
          subscriptionData.expirationDate,
        ));
      } else {
        emit(CheckSubscriptionInactive());
      }
    } catch (e) {
      emit(CheckSubscriptionError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSubscriptionStatus(
    UpdateSubscriptionStatus event,
    Emitter<CheckStatusSubscriptionState> emit,
  ) async {
    // Similarly, if the subscription remains valid (even after cancellation),
    // treat it as active.
    if (event.isValid) {
      emit(CheckSubscriptionActive(
        event.subscriptionLevel,
        event.isValid,
        event.expirationDate,
      ));
    } else {
      emit(CheckSubscriptionInactive());
    }
  }
}
