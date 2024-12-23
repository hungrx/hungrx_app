import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';

abstract class SuggestedRestaurantsState {}

class SuggestedRestaurantsInitial extends SuggestedRestaurantsState {}

class SuggestedRestaurantsLoading extends SuggestedRestaurantsState {}

class SuggestedRestaurantsLoaded extends SuggestedRestaurantsState {
  final List<SuggestedRestaurantModel> restaurants;

  SuggestedRestaurantsLoaded(this.restaurants);
}

class SuggestedRestaurantsError extends SuggestedRestaurantsState {
  final String message;

  SuggestedRestaurantsError(this.message);
}