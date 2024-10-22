abstract class OtpAuthState {}

class OtpAuthInitial extends OtpAuthState {}

class OtpSendLoading extends OtpAuthState {}

class OtpSendSuccess extends OtpAuthState {}

class OtpSendFailure extends OtpAuthState {
  final String error;

  OtpSendFailure(this.error);
}

class OtpVerifyLoading extends OtpAuthState {}

class OtpVerifySuccess extends OtpAuthState {
  final String token;

  OtpVerifySuccess(this.token);
}

class OtpVerifyFailure extends OtpAuthState {
  final String error;

  OtpVerifyFailure(this.error);
}