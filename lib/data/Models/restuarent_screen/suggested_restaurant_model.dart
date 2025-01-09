class RestaurantsResponse {
  final bool status;
  final List<SuggestedRestaurantModel> restaurants;

  RestaurantsResponse({
    required this.status,
    required this.restaurants,
  });

  factory RestaurantsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantsResponse(
      status: json['status'] ?? false,
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((restaurant) => SuggestedRestaurantModel.fromJson(restaurant))
          .toList() ?? [],
    );
  }
}

class SuggestedRestaurantModel {
  final String id;
  final String name;
  final String? address;
  final Map<String, dynamic>? coordinates;
  final double? distance;
  final String? logo; // Added logo field

  SuggestedRestaurantModel({
    required this.id,
    required this.name,
    this.address,
    this.coordinates,
    this.distance,
    required this.logo, // Made logo required since it always comes in the response
  });

  factory SuggestedRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SuggestedRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      coordinates: json['coordinates'],
      distance: json['distance']?.toDouble(),
      logo: json['logo'],
    );
  }
}