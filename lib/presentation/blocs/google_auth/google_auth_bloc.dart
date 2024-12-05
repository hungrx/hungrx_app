import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/errors/google_auth_error.dart';
import '../../../domain/usecases/google_auth_usecase.dart';
import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final GoogleAuthUseCase googleAuthUseCase;

  GoogleAuthBloc({required this.googleAuthUseCase}) : super(GoogleAuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<GoogleSignOutRequested>(_onGoogleSignOutRequested);
  }

void _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      // print('Starting Google Sign-In process');
      final user = await googleAuthUseCase.signIn();
      
      if (user != null) {
        // print('Google Sign-In successful: ${user.displayName}');
        emit(GoogleAuthSuccess(user));
      } else {
        // print('Google Sign-In failed: User is null');
        emit(GoogleAuthFailure(error: 'Sign-In failed: Unable to retrieve user information'));
      }
    }  on GoogleAuthException catch (e) {
        if (e.isCancelled) {
          emit(GoogleAuthCancelled());
        } else {
          emit(GoogleAuthFailure(error: e.message));
        }
      } catch (e) {
        emit(GoogleAuthFailure(error: e.toString()));
      }
  }

  void _onGoogleSignOutRequested(
    GoogleSignOutRequested event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      // print('Starting Google Sign-Out process');
      await googleAuthUseCase.signOut();
      // print('Google Sign-Out successful');
      emit(GoogleAuthInitial());
    } catch (e) {
      // print('Error during Google Sign-Out: $e');
      emit(GoogleAuthFailure(error: 'Sign-Out failed: ${e.toString()}'));
    }
  }
}