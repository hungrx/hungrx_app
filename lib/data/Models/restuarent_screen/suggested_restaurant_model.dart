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

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'restaurants': restaurants.map((restaurant) => restaurant.toJson()).toList(),
    };
  }
}

class SuggestedRestaurantModel {
  final String id;
  final String name;
  final String? address;
  final Map<String, dynamic>? coordinates;
  final double? distance;
  final String? logo;

  SuggestedRestaurantModel({
    required this.id,
    required this.name,
    this.address,
    this.coordinates,
    this.distance,
    required this.logo,
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'coordinates': coordinates,
      'distance': distance,
      'logo': logo,
    };
  }

  bool equals(SuggestedRestaurantModel other) {
    return id == other.id &&
        name == other.name &&
        address == other.address &&
        logo == other.logo &&
        distance == other.distance;
  }
}