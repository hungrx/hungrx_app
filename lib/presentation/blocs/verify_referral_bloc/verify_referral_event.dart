abstract class VerifyReferralEvent {
  const VerifyReferralEvent();
}

// Remove userId from VerifyReferralSubmitted event
class VerifyReferralSubmitted extends VerifyReferralEvent {
  final String referralCode;

  const VerifyReferralSubmitted({
    required this.referralCode,
  });
}