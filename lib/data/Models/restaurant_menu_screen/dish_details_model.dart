import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_screen.dart';

class DishDetailsModel {
  final String name;
  final String? imageUrl;
  final String description;
  final List<String> servingSizes;
  final Map<String, NutritionInfo> sizeOptions;
  final List<String> ingredients;

  DishDetailsModel({
    required this.name,
    this.imageUrl,
    required this.description,
    required this.servingSizes,
    required this.sizeOptions,
    required this.ingredients,
  });

  factory DishDetailsModel.fromJson(Map<String, dynamic> json) {
    return DishDetailsModel(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      servingSizes: List<String>.from(json['servingSizes'] ?? []),
      sizeOptions: (json['sizeOptions'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, NutritionInfo.fromJson(value)),
          ) ?? {},
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }
}