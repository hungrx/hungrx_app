import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';

abstract class RestaurantMenuState {}

class RestaurantMenuInitial extends RestaurantMenuState {}

class RestaurantMenuLoading extends RestaurantMenuState {}

class RestaurantMenuLoaded extends RestaurantMenuState {
  final RestaurantMenuResponse menuResponse;

  RestaurantMenuLoaded(this.menuResponse);
}

class RestaurantMenuError extends RestaurantMenuState {
  final String message;

  RestaurantMenuError(this.message);
}