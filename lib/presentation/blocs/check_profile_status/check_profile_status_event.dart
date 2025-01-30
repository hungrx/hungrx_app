// Modified Event classes
abstract class ProfileCheckEvent {}
class CheckUserProfile extends ProfileCheckEvent {
  CheckUserProfile(); // No longer needs userId parameter
}
