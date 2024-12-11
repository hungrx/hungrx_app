abstract class GetProfileDetailsEvent {}

class FetchProfileDetails extends GetProfileDetailsEvent {
  final String userId;
  FetchProfileDetails({required this.userId});
}
