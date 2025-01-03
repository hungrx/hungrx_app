// lib/data/models/restaurant_menu_response.dart
class RestaurantMenuResponse {
  final bool success;
  final RestaurantMenu menu;
  final UserStats userStats;

  RestaurantMenuResponse({
    required this.success,
    required this.menu,
    required this.userStats,
  });

  factory RestaurantMenuResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantMenuResponse(
      success: json['success'] ?? false,
      menu: RestaurantMenu.fromJson(json['menu'] ?? {}),
      userStats: UserStats.fromJson(json['userStats'] ?? {}),
    );
  }
}

class RestaurantMenu {
  final String id;
  final String restaurantName;
  final String logo;
  final List<MenuCategory> categories;

  RestaurantMenu({
    required this.id,
    required this.restaurantName,
    required this.logo,
    required this.categories,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      id: json['_id'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      logo: json['logo'] ?? '',
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => MenuCategory.fromJson(e))
          .toList(),
    );
  }
}

class MenuCategory {
  final String id;
  final String categoryName;
  final List<Dish> dishes;
  final List<SubCategory> subCategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuCategory({
    required this.id,
    required this.categoryName,
    required this.dishes,
    required this.subCategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      dishes: (json['dishes'] as List<dynamic>? ?? [])
          .map((e) => Dish.fromJson(e))
          .toList(),
      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategory.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class SubCategory {
  final String id;
  final String subCategoryName;
  final List<Dish> dishes;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubCategory({
    required this.id,
    required this.subCategoryName,
    required this.dishes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
      dishes: (json['dishes'] as List<dynamic>? ?? [])
          .map((e) => Dish.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Dish {
  final String id;
  final String dishName;
  final String description;
  final List<ServingInfo> servingInfos;
  final DateTime createdAt;
  final DateTime updatedAt;

  Dish({
    required this.id,
    required this.dishName,
    required this.description,
    required this.servingInfos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['_id'] ?? '',
      dishName: json['dishName'] ?? '',
      description: json['description'] ?? '',
      servingInfos: (json['servingInfos'] as List<dynamic>? ?? [])
          .map((e) => ServingInfo.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ServingInfo {
  final String id;
  final ServingDetails servingInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServingInfo({
    required this.id,
    required this.servingInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      id: json['_id'] ?? '',
      servingInfo: ServingDetails.fromJson(json['servingInfo'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ServingDetails {
  final String size;
  final String price;
  final String? url;
  final NutritionFacts nutritionFacts;

  ServingDetails({

    required this.size,
    required this.price,
    this.url,
    required this.nutritionFacts,
  });

  factory ServingDetails.fromJson(Map<String, dynamic> json) {
    return ServingDetails(
      size: json['size'] ?? '',
      price: json['price'] ?? '',
      url: json['Url'], 
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
    );
  }
}

class NutritionFacts {
  final NutritionValue calories;
  final NutritionValue protein;
  final NutritionValue carbs;
  final NutritionValue totalFat;

  NutritionFacts({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.totalFat,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: NutritionValue.fromJson(json['calories'] ?? {}),
      protein: NutritionValue.fromJson(json['protein'] ?? {}),
      carbs: NutritionValue.fromJson(json['carbs'] ?? {}),
      totalFat: NutritionValue.fromJson(json['totalFat'] ?? {}),
    );
  }
}

class NutritionValue {
  final String value;
  final String unit;

  NutritionValue({
    required this.value,
    required this.unit,
  });

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      value: json['value']?.toString() ?? '0',
      unit: json['unit'] ?? '',
    );
  }
}

class UserStats {
  final String dailyCalorieGoal;
  final double todayConsumption;

  UserStats({
    required this.dailyCalorieGoal,
    required this.todayConsumption,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      dailyCalorieGoal: json['dailyCalorieGoal']?.toString() ?? '0',
      todayConsumption: (json['todayConsumption'] as num?)?.toDouble() ?? 0.0,
    );
  }
}