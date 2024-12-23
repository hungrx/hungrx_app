class SuggestedRestaurantModel {
  final String id;
  final String name;
  final String? address;
  final Map<String, dynamic>? coordinates;
  final double? distance;

  SuggestedRestaurantModel({
    required this.id,
    required this.name,
    this.address,
    this.coordinates,
    this.distance,
  });

  factory SuggestedRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SuggestedRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      coordinates: json['coordinates'],
      distance: json['distance']?.toDouble(),
    );
  }
}