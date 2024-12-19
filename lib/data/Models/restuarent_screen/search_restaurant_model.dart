import 'package:equatable/equatable.dart';

class SearchRestaurantModel extends Equatable {
  final String id;
  final String name;
  final String logo;

  const SearchRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SearchRestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, logo];
}