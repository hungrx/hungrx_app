import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/check_user_profile_usecase.dart';
import 'package:hungrx_app/presentation/blocs/check_profile_status/check_profile_status_event.dart';
import 'package:hungrx_app/presentation/blocs/check_profile_status/check_profile_status_state.dart';

class ProfileCheckBloc extends Bloc<ProfileCheckEvent, ProfileCheckState> {
  final CheckUserProfileUseCase _checkUserProfileUseCase;

  ProfileCheckBloc(this._checkUserProfileUseCase) : super(ProfileCheckInitial()) {
    on<CheckUserProfile>(_onCheckUserProfile);
  }

  Future<void> _onCheckUserProfile(
    CheckUserProfile event,
    Emitter<ProfileCheckState> emit,
  ) async {
    emit(ProfileCheckLoading());
    try {
      final isComplete = await _checkUserProfileUseCase.execute(event.userId);
      emit(ProfileCheckComplete(isComplete));
    } catch (e) {
      emit(ProfileCheckError(e.toString()));
    }
  }
}