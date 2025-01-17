abstract class RequestRestaurantEvent {}

class SubmitRequestRestaurantEvent extends RequestRestaurantEvent {
  final String restaurantName;
  final String restaurantType;
  final String area;

  SubmitRequestRestaurantEvent({
    required this.restaurantName,
    required this.restaurantType,
    required this.area,
  });
}