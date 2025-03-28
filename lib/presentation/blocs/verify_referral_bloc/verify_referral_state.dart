abstract class VerifyReferralState {
  const VerifyReferralState();
}

class VerifyReferralInitial extends VerifyReferralState {}

class VerifyReferralLoading extends VerifyReferralState {}

class VerifyReferralSuccess extends VerifyReferralState {
  final String message;
  final Map<String, dynamic> data;

  const VerifyReferralSuccess({
    required this.message,
    required this.data,
  });
}

class VerifyReferralFailure extends VerifyReferralState {
  final String error;

  const VerifyReferralFailure({required this.error});
}