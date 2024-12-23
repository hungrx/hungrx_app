import 'package:equatable/equatable.dart';

abstract class NearbyRestaurantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNearbyRestaurants extends NearbyRestaurantEvent {}