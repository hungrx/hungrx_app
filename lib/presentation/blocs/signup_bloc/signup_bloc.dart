import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpBloc({required this.signUpUseCase}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      if (event.password != event.reenterPassword) {
        emit(SignUpFailure("Passwords do not match"));
        return;
      }
      
      final response = await signUpUseCase.execute(event.email, event.password);
      // print(response.message);
      if (response.success) {
        // print(response.message);
        emit(SignUpSuccess());
      } else {
        emit(SignUpFailure(response.message));
      }
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}