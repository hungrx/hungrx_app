import 'package:equatable/equatable.dart';

abstract class NearbyRestaurantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNearbyRestaurants extends NearbyRestaurantEvent {}
// In nearby_restaurant_event.dart
class UpdateSearchRadius extends NearbyRestaurantEvent {
  final double radius;

  UpdateSearchRadius(this.radius);

  @override
  List<Object?> get props => [radius];
}