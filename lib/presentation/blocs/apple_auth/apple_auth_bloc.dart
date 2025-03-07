import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/apple_sign_in_usecase.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_state.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthBloc extends Bloc<AppleAuthEvent, AppleAuthState> {
  final AppleSignInUseCase _appleSignInUseCase;

  AppleAuthBloc({required AppleSignInUseCase appleSignInUseCase})
      : _appleSignInUseCase = appleSignInUseCase,
        super(AppleAuthInitial()) {
    on<AppleSignInRequested>(_onAppleSignInRequested);
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AppleAuthState> emit,
  ) async {
    emit(AppleAuthLoading());
    try {
      final credential = await _appleSignInUseCase.execute();
      emit(AppleAuthSuccess(credential));
    } catch (e) {
      // Handle SignInWithApple specific errors
      if (e is SignInWithAppleAuthorizationException) {
        switch (e.code) {
          case AuthorizationErrorCode.canceled:
            emit(AppleAuthCancelled());
            return;
          case AuthorizationErrorCode.failed:
            emit(AppleAuthFailure('Authentication failed: ${e.message}'));
            return;
          case AuthorizationErrorCode.invalidResponse:
            emit(AppleAuthFailure('Invalid response received'));
            return;
          case AuthorizationErrorCode.notHandled:
            emit(AppleAuthFailure('Authentication not handled'));
            return;
          default:
            emit(AppleAuthFailure('Unknown error occurred'));
            return;
        }
      }

      // Handle other general errors
      emit(AppleAuthFailure(e.toString()));
    }
  }
}
