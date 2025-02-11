import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/apple_sign_in_usecase.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_state.dart';

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
      print(e);
      emit(AppleAuthFailure(e.toString()));
    }
  }
}

