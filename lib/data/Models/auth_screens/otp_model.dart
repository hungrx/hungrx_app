class OtpSendModel {
  final String phoneNumber;

  OtpSendModel({required this.phoneNumber});

  Map<String, dynamic> toJson() => {'mobile': phoneNumber};
}

class OtpVerifyModel {
  final String phoneNumber;
  final String otp;

  OtpVerifyModel({required this.phoneNumber, required this.otp});

  Map<String, dynamic> toJson() => {'mobile': phoneNumber, 'otp': otp};
}