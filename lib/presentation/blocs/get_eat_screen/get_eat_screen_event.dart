abstract class EatScreenEvent {}

class GetEatScreenDataEvent extends EatScreenEvent {
  // Removed userId parameter since it will be fetched from AuthService
  GetEatScreenDataEvent();
}