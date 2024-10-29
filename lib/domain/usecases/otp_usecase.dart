import 'package:hungrx_app/data/models/otp_model.dart';
import '../../data/repositories/otp_repository.dart';

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
