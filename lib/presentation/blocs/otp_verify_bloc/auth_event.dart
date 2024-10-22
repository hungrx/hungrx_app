abstract class OtpAuthEvent {}

class SendOtpEvent extends OtpAuthEvent {
  final String phoneNumber;

  SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends OtpAuthEvent {
  final String phoneNumber;
  final String otp;

  VerifyOtpEvent(this.phoneNumber, this.otp);
}