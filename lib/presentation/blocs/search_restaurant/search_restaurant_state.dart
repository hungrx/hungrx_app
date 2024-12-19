import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/search_restaurant_model.dart';

abstract class RestaurantSearchState extends Equatable {
  const RestaurantSearchState();

  @override
  List<Object?> get props => [];
}

class RestaurantSearchInitial extends RestaurantSearchState {}

class RestaurantSearchLoading extends RestaurantSearchState {}

class RestaurantSearchSuccess extends RestaurantSearchState {
  final List<SearchRestaurantModel> restaurants;

  const RestaurantSearchSuccess(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantSearchEmpty extends RestaurantSearchState {}

class RestaurantSearchError extends RestaurantSearchState {
  final String message;

  const RestaurantSearchError(this.message);

  @override
  List<Object> get props => [message];
}