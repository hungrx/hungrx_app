abstract class RequestRestaurantState {}

class RequestRestaurantInitial extends RequestRestaurantState {}

class RequestRestaurantLoading extends RequestRestaurantState {}

class RequestRestaurantSuccess extends RequestRestaurantState {}

class RequestRestaurantFailure extends RequestRestaurantState {
  final String error;
  RequestRestaurantFailure(this.error);
}