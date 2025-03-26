part of 'referral_bloc.dart';

abstract class ReferralEvent {}

// Remove userId from GenerateReferralCode event
class GenerateReferralCode extends ReferralEvent {
  GenerateReferralCode(); // No longer needs userId parameter
}