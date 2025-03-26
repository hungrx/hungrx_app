import 'package:bloc/bloc.dart';
import 'package:hungrx_app/data/repositories/profile_screen/referral_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';

part 'referral_event.dart';
part 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final ReferralRepository repository;
  final AuthService _authService; // Add AuthService

  ReferralBloc({
    required this.repository,
    required AuthService authService, // Inject AuthService
  }) : _authService = authService,
       super(ReferralInitial()) {
    on<GenerateReferralCode>(_onGenerateReferralCode);
  }

  Future<void> _onGenerateReferralCode(
    GenerateReferralCode event,
    Emitter<ReferralState> emit,
  ) async {
    emit(ReferralLoading());

    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(ReferralFailure(error: 'User not logged in'));
        return;
      }

      final result = await repository.generateReferralCode(userId);

      result.fold(
        (failure) => emit(ReferralFailure(error: failure.message)),
        (referral) => emit(ReferralSuccess(referralCode: referral.referralCode)),
      );
    } catch (e) {
      emit(ReferralFailure(error: e.toString()));
    }
  }
}

