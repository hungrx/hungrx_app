import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/check_user_profile_usecase.dart';
import 'package:hungrx_app/presentation/blocs/check_profile_status/check_profile_status_event.dart';
import 'package:hungrx_app/presentation/blocs/check_profile_status/check_profile_status_state.dart';

class ProfileCheckBloc extends Bloc<ProfileCheckEvent, ProfileCheckState> {
  final CheckUserProfileUseCase _checkUserProfileUseCase;
  final AuthService _authService; // Add AuthService

  ProfileCheckBloc(
    this._checkUserProfileUseCase,
    this._authService, // Inject AuthService
  ) : super(ProfileCheckInitial()) {
    on<CheckUserProfile>(_onCheckUserProfile);
  }

  Future<void> _onCheckUserProfile(
    CheckUserProfile event,
    Emitter<ProfileCheckState> emit,
  ) async {
    emit(ProfileCheckLoading());
    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(ProfileCheckError('User not logged in'));
        return;
      }

      final isComplete = await _checkUserProfileUseCase.execute(userId);
      emit(ProfileCheckComplete(isComplete));
    } catch (e) {
      emit(ProfileCheckError(e.toString()));
    }
  }
}

