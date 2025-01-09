// restaurant_search_event.dart
abstract class RestaurantSearchEvent {}

class SearchRestaurants extends RestaurantSearchEvent {
  final String query;

  SearchRestaurants(this.query);
}

class ClearRestaurantSearch extends RestaurantSearchEvent {}