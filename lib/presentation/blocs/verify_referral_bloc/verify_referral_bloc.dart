import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/profile_screen/verify_referral_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/verify_referral_bloc/verify_referral_event.dart';
import 'package:hungrx_app/presentation/blocs/verify_referral_bloc/verify_referral_state.dart';

class VerifyReferralBloc
    extends Bloc<VerifyReferralEvent, VerifyReferralState> {
  final VerifyReferralRepository _repository;
  final AuthService _authService; // Add AuthService

  VerifyReferralBloc({
    VerifyReferralRepository? repository,
    required AuthService authService, // Inject AuthService
  })  : _repository = repository ?? VerifyReferralRepository(),
        _authService = authService,
        super(VerifyReferralInitial()) {
    on<VerifyReferralSubmitted>(_onVerifyReferralSubmitted);
  }

  Future<void> _onVerifyReferralSubmitted(
    VerifyReferralSubmitted event,
    Emitter<VerifyReferralState> emit,
  ) async {
    try {
      emit(VerifyReferralLoading());

      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(VerifyReferralFailure(error: 'User not logged in'));
        return;
      }

      final result = await _repository.verifyReferralCode(
        userId,
        event.referralCode,
      );

      if (result['success']) {
        emit(VerifyReferralSuccess(
          message: result['message'],
          data: result['data'],
        ));
      } else {
        emit(VerifyReferralFailure(error: result['message']));
      }
    } catch (e) {
      emit(VerifyReferralFailure(error: 'Failed to verify referral code'));
    }
  }
}
