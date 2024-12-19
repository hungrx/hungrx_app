abstract class RestaurantSearchEvent {}

class RestaurantSearchQueryChanged extends RestaurantSearchEvent {
  final String query;
  RestaurantSearchQueryChanged(this.query);
}