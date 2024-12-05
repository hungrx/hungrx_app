abstract class EatScreenEvent {}

class GetEatScreenDataEvent extends EatScreenEvent {
  final String userId;
  GetEatScreenDataEvent(this.userId);
}