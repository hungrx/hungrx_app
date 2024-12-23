import 'package:equatable/equatable.dart';

class NearbyRestaurantModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final List<double> coordinates;
  final double distance;

  const NearbyRestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.distance,
  });

  factory NearbyRestaurantModel.fromJson(Map<String, dynamic> json) {
    return NearbyRestaurantModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
      distance: (json['distance'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, name, address, coordinates, distance];
}