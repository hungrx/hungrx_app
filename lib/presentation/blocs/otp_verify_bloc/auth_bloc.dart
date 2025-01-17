import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/otp_usecase.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_event.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_state.dart';

class OtpAuthBloc extends Bloc<OtpAuthEvent, OtpAuthState> {
  final OtpUseCase otpUseCase;

  OtpAuthBloc({required this.otpUseCase}) : super(OtpAuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event, Emitter<OtpAuthState> emit) async {
    emit(OtpSendLoading());
    try {
      await otpUseCase.sendOtp(event.phoneNumber);
      emit(OtpSendSuccess());
    } catch (e) {
      emit(OtpSendFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<OtpAuthState> emit) async {
    emit(OtpVerifyLoading());
    try {
      final token = await otpUseCase.verifyOtp(event.phoneNumber, event.otp);
      emit(OtpVerifySuccess(token));
    } catch (e) {
      emit(OtpVerifyFailure(e.toString()));
    }
  }
}
