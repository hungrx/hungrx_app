import 'package:hungrx_app/data/Models/auth_screens/otp_model.dart';
import 'package:hungrx_app/data/repositories/otp_auth_screen/otp_repository.dart';

class OtpUseCase {
  final OtpRepository repository;

  OtpUseCase(this.repository);

  Future<void> sendOtp(String phoneNumber) async {
    final otpSendModel = OtpSendModel(phoneNumber: phoneNumber);
    await repository.sendOtp(otpSendModel);
  }

  Future<String> verifyOtp(String phoneNumber, String otp) async {
    final otpVerifyModel = OtpVerifyModel(phoneNumber: phoneNumber, otp: otp);
    return await repository.verifyOtp(otpVerifyModel);
  }
}
