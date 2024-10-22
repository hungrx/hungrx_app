import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/facebook_auth_usecase.dart';
import 'facebook_auth_event.dart';
import 'facebook_auth_state.dart';

class FacebookAuthBloc extends Bloc<FacebookAuthEvent, FacebookAuthState> {
  final FacebookAuthUseCase facebookAuthUseCase;

  FacebookAuthBloc({required this.facebookAuthUseCase}) : super(FacebookAuthInitial()) {
    on<FacebookSignInRequested>(_onFacebookSignInRequested);
    on<FacebookSignOutRequested>(_onFacebookSignOutRequested);
  }

  Future<void> _onFacebookSignInRequested(FacebookSignInRequested event, Emitter<FacebookAuthState> emit) async {
    emit(FacebookAuthLoading());
    try {
      final token = await facebookAuthUseCase.execute();
      emit(FacebookAuthSuccess(token));
    } catch (e) {
      emit(FacebookAuthFailure(e.toString()));
    }
  }

  Future<void> _onFacebookSignOutRequested(FacebookSignOutRequested event, Emitter<FacebookAuthState> emit) async {
    emit(FacebookAuthLoading());
    try {
      await facebookAuthUseCase.signOut();
      emit(FacebookAuthInitial());
    } catch (e) {
      emit(FacebookAuthFailure(e.toString()));
    }
  }
}