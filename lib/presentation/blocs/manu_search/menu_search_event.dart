import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';

abstract class SearchEvent {}

class SearchDishes extends SearchEvent {
  final String query;
  final List<MenuCategory> categories;

  SearchDishes(this.query, this.categories);
}

class ClearSearch extends SearchEvent {
  ClearSearch();
}
