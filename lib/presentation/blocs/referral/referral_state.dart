part of 'referral_bloc.dart';

abstract class ReferralState {}

class ReferralInitial extends ReferralState {}

class ReferralLoading extends ReferralState {}

class ReferralSuccess extends ReferralState {
  final String referralCode;
  ReferralSuccess({required this.referralCode});
}

class ReferralFailure extends ReferralState {
  final String error;
  ReferralFailure({required this.error});
}