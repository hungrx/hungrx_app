abstract class GetProfileDetailsEvent {}

class FetchProfileDetails extends GetProfileDetailsEvent {
  // Removed userId parameter since it will be fetched from AuthService
  FetchProfileDetails();
}
