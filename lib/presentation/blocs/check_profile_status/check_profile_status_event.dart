abstract class ProfileCheckEvent {}

class CheckUserProfile extends ProfileCheckEvent {
  final String userId;
  CheckUserProfile(this.userId);
}
