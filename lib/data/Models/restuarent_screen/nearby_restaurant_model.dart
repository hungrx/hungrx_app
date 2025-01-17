import 'package:equatable/equatable.dart';

class NearbyRestaurantResponse extends Equatable {
  final bool success;
  final List<NearbyRestaurantModel> data;
  final int total;

  const NearbyRestaurantResponse({
    required this.success,
    required this.data,
    required this.total,
  });

  factory NearbyRestaurantResponse.fromJson(Map<String, dynamic> json) {
    return NearbyRestaurantResponse(
      success: json['success'] as bool,
      data: List<NearbyRestaurantModel>.from(
        json['data'].map((x) => NearbyRestaurantModel.fromJson(x)),
      ),
      total: json['total'] as int,
    );
  }

  @override
  List<Object?> get props => [success, data, total];
}

class NearbyRestaurantModel extends Equatable {
  final String id;
  final String restaurantName;
  final String logo;
  final String address;
  final num distance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const NearbyRestaurantModel({
    required this.id,
    required this.restaurantName,
    required this.logo,
    required this.address,
    required this.distance,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory NearbyRestaurantModel.fromJson(Map<String, dynamic> json) {
    try {
      return NearbyRestaurantModel(
        id: json['_id'] as String? ?? '',
        restaurantName: json['restaurantName'] as String? ?? '',
        logo: json['logo'] as String? ?? '',
        address: json['address'] as String? ?? '',
        distance: json['distance'] as num? ?? 0,
        createdAt: json['createdAt'] != null 
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null 
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
        version: json['__v'] as int? ?? 0,
      );
    } catch (e) {
      print('Error parsing NearbyRestaurantModel: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        id,
        restaurantName,
        logo,
        address,
        distance,
        createdAt,
        updatedAt,
        version,
      ];
}
