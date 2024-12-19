import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth_screens/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // print("reached");
      final token = await loginUseCase.execute(event.email, event.password);
      // print("hi whaht up$token");
      emit(LoginSuccess(token));
    } catch (e) {
      //  print("error occures$e");
      emit(LoginFailure(e.toString()));
    }
  }
}