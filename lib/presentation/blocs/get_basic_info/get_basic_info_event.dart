abstract class GetBasicInfoEvent {}

class GetBasicInfoRequested extends GetBasicInfoEvent {
  final String userId;
  GetBasicInfoRequested(this.userId);
}