import 'package:flutter_bloc/flutter_bloc.dart';
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
      print('Starting Google Sign-In process');
      final user = await googleAuthUseCase.signIn();
      
      if (user != null) {
        print('Google Sign-In successful: ${user.displayName}');
        emit(GoogleAuthSuccess(user));
      } else {
        print('Google Sign-In failed: User is null');
        emit(GoogleAuthFailure('Sign-In failed: Unable to retrieve user information'));
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      String errorMessage = 'An unexpected error occurred';
      if (e.toString().contains('Invalid response format')) {
        errorMessage = 'Server response was not in the expected format. Please try again later.';
      } else if (e.toString().contains('Failed to store user')) {
        errorMessage = 'Failed to store user information. Please try again.';
      }
      emit(GoogleAuthFailure(errorMessage));
    }
  }

  void _onGoogleSignOutRequested(
    GoogleSignOutRequested event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      print('Starting Google Sign-Out process');
      await googleAuthUseCase.signOut();
      print('Google Sign-Out successful');
      emit(GoogleAuthInitial());
    } catch (e) {
      print('Error during Google Sign-Out: $e');
      emit(GoogleAuthFailure('Sign-Out failed: ${e.toString()}'));
    }
  }
}