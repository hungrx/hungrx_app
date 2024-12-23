import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';

abstract class NearbyRestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NearbyRestaurantInitial extends NearbyRestaurantState {}

class NearbyRestaurantLoading extends NearbyRestaurantState {}

class NearbyRestaurantLoaded extends NearbyRestaurantState {
  final List<NearbyRestaurantModel> restaurants;

  NearbyRestaurantLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class NearbyRestaurantError extends NearbyRestaurantState {
  final String message;

  NearbyRestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}