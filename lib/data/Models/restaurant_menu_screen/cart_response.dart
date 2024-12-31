class CartResponse {
  final bool status;
  final String message;
  final List<DishDetails> dishes;

  CartResponse({
    required this.status,
    required this.message,
    required this.dishes,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      dishes: (json['dishes'] as List?)
          ?.map((dish) => DishDetails.fromJson(dish))
          .toList() ?? [],
    );
  }
}

class DishDetails {
  final String restaurantId;
  final String restaurantName;
  final String categoryName;
  final String subCategoryName;
  final String dishId;
  final String dishName;
  final String servingSize;
  final NutritionInfo nutritionInfo;

  DishDetails({
    required this.restaurantId,
    required this.restaurantName,
    required this.categoryName,
    required this.subCategoryName,
    required this.dishId,
    required this.dishName,
    required this.servingSize,
    required this.nutritionInfo,
  });

  factory DishDetails.fromJson(Map<String, dynamic> json) {
    return DishDetails(
      restaurantId: json['restaurantId'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
      dishId: json['dishId'] ?? '',
      dishName: json['dishName'] ?? '',
      servingSize: json['servingSize'] ?? '',
      nutritionInfo: NutritionInfo.fromJson(json['nutritionInfo'] ?? {}),
    );
  }
}

class NutritionInfo {
  final NutritionValue calories;
  final NutritionValue protein;
  final NutritionValue carbs;
  final NutritionValue totalFat;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.totalFat,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
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

  NutritionValue({required this.value, required this.unit});

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      value: json['value']?.toString() ?? '0',
      unit: json['unit']?.toString() ?? '',
    );
  }
}