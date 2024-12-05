class SearchResponseModel {
  final bool status;
  final int count; // Changed from double to int
  final List<SearchItemModel> data;

  SearchResponseModel({
    required this.status,
    required this.count,
    required this.data,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      status: json['status'] ?? false,
      count: (json['count'] ?? 0).toInt(), // Ensure we get an int
      data: (json['data'] as List?)
              ?.map((item) => SearchItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SearchItemModel {
  final String type;
  final bool isRestaurant;
  final String id;
  final String name;
  final String? image;
  final NutritionFacts? nutritionFacts;
  final RestaurantMenu? menu;
  final String? calorieBurnNote; // Added this field based on your JSON
  final Map<String, dynamic>? category; // Added for category information
  final Map<String, dynamic>? servingInfo; // Added for serving information

  SearchItemModel({
    required this.type,
    required this.isRestaurant,
    required this.id,
    required this.name,
    this.image,
    this.nutritionFacts,
    this.menu,
    this.calorieBurnNote,
    this.category,
    this.servingInfo,
  });

  factory SearchItemModel.fromJson(Map<String, dynamic> json) {
    return SearchItemModel(
      type: json['type'] ?? '',
      isRestaurant: json['isRestaurant'] ?? false,
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      calorieBurnNote: json['calorieBurnNote'],
      category: json['category'] as Map<String, dynamic>?,
      servingInfo: json['servingInfo'] as Map<String, dynamic>?,
      nutritionFacts: json['nutritionFacts'] != null
          ? NutritionFacts.fromJson(json['nutritionFacts'])
          : null,
      menu: json['menus'] != null
          ? RestaurantMenu.fromJson(json['menus'][0])
          : null,
    );
  }
}

class NutritionFacts {
  final double calories; // Changed to double since API sends decimal values
  final NutrientValue totalFat;
  final NutrientValue saturatedFat; // Added based on your JSON
  final NutrientValue cholesterol; // Added based on your JSON
  final NutrientValue sodium; // Added based on your JSON
  final NutrientValue totalCarbohydrate; // Added based on your JSON
  final NutrientValue dietaryFiber; // Added based on your JSON
  final NutrientValue sugars; // Added based on your JSON
  final NutrientValue protein;
  final NutrientValue potassium; // Added based on your JSON

  NutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.protein,
    required this.saturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrate,
    required this.dietaryFiber,
    required this.sugars,
    required this.potassium,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: (json['calories'] ?? 0).toDouble(),
      totalFat: NutrientValue.fromJson(json['totalFat'] ?? {}),
      saturatedFat: NutrientValue.fromJson(json['saturatedFat'] ?? {}),
      cholesterol: NutrientValue.fromJson(json['Cholesterol'] ?? {}),
      sodium: NutrientValue.fromJson(json['Sodium'] ?? {}),
      totalCarbohydrate:
          NutrientValue.fromJson(json['totalCarbohydrate'] ?? {}),
      dietaryFiber: NutrientValue.fromJson(json['DietaryFiber'] ?? {}),
      sugars: NutrientValue.fromJson(json['Sugars'] ?? {}),
      protein: NutrientValue.fromJson(json['Protein'] ?? {}),
      potassium: NutrientValue.fromJson(
          json['Potassiun'] ?? {}), // Note: API has a typo in 'Potassiun'
    );
  }
}

class NutrientValue {
  final double value;
  final String? unit;

  NutrientValue({
    required this.value,
    this.unit,
  });

  factory NutrientValue.fromJson(Map<String, dynamic> json) {
    return NutrientValue(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'],
    );
  }
}

class RestaurantMenu {
  final String id;
  final String name;
  final List<MenuItem> dishes;

  RestaurantMenu({
    required this.id,
    required this.name,
    required this.dishes,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dishes: (json['dishes'] as List?)
              ?.map((dish) => MenuItem.fromJson(dish))
              .toList() ??
          [],
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final String? image;
  final NutritionFacts? nutritionFacts;

  MenuItem({
    required this.id,
    required this.name,
    this.image,
    this.nutritionFacts,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      nutritionFacts: json['nutritionFacts'] != null
          ? NutritionFacts.fromJson(json['nutritionFacts'])
          : null,
    );
  }
}
