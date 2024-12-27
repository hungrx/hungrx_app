import 'package:equatable/equatable.dart';

abstract class RestaurantMenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRestaurantMenu extends RestaurantMenuEvent {
  final String restaurantId;

  LoadRestaurantMenu({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}