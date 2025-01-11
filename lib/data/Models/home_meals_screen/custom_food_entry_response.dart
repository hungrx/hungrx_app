class CustomFoodEntryResponse {
  final bool success;
  final String message;
  final String date;
  final String mealId;
  final FoodDetails foodDetails;
  final UpdatedMeal updatedMeal;

  CustomFoodEntryResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.mealId,
    required this.foodDetails,
    required this.updatedMeal,
  });

  factory CustomFoodEntryResponse.fromJson(Map<String, dynamic> json) {
    return CustomFoodEntryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      mealId: json['mealId'] ?? '',
      foodDetails: FoodDetails.fromJson(json['foodDetails'] ?? {}),
      updatedMeal: UpdatedMeal.fromJson(json['updatedMeal'] ?? {}),
    );
  }
}

class FoodDetails {
  final String id;
  final String name;
  final String brandName;
  final NutritionFacts nutritionFacts;
  final ServingInfo servingInfo;
  final bool isCustomFood;
  final String mealType;
  final String mealId;

  FoodDetails({
    required this.id,
    required this.name,
    required this.brandName,
    required this.nutritionFacts,
    required this.servingInfo,
    required this.isCustomFood,
    required this.mealType,
    required this.mealId,
  });

  factory FoodDetails.fromJson(Map<String, dynamic> json) {
    return FoodDetails(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      servingInfo: ServingInfo.fromJson(json['servingInfo'] ?? {}),
      isCustomFood: json['isCustomFood'] ?? false,
      mealType: json['mealType'] ?? '',
      mealId: json['mealId'] ?? '',
    );
  }
}

class NutritionFacts {
  final int calories;

  NutritionFacts({
    required this.calories,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    // Convert calories to int if it's a double
    final caloriesValue = json['calories'] ?? 0;
    return NutritionFacts(
      calories: caloriesValue is double ? caloriesValue.round() : caloriesValue,
    );
  }
}

class ServingInfo {
  final int size;
  final String unit;

  ServingInfo({
    required this.size,
    required this.unit,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: json['size'] ?? 1,
      unit: json['unit'] ?? 'serving',
    );
  }
}

class UpdatedMeal {
  final String mealId;
  final List<FoodItem> foods;

  UpdatedMeal({
    required this.mealId,
    required this.foods,
  });

  factory UpdatedMeal.fromJson(Map<String, dynamic> json) {
    return UpdatedMeal(
      mealId: json['mealId'] ?? '',
      foods: (json['foods'] as List<dynamic>?)
          ?.map((food) => FoodItem.fromJson(food))
          .toList() ?? [],
    );
  }
}

class FoodItem {
  final int servingSize;
  final String selectedMeal;
  final String dishId;
  final int totalCalories;
  final DateTime timestamp;
  final String name;
  final String brandName;
  final NutritionFacts nutritionFacts;
  final ServingInfo servingInfo;
  final bool isCustomFood;
  final String foodId;

  FoodItem({
    required this.servingSize,
    required this.selectedMeal,
    required this.dishId,
    required this.totalCalories,
    required this.timestamp,
    required this.name,
    required this.brandName,
    required this.nutritionFacts,
    required this.servingInfo,
    required this.isCustomFood,
    required this.foodId,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    final totalCaloriesValue = json['totalCalories'] ?? 0;
    return FoodItem(
      servingSize: json['servingSize'] ?? 1,
      selectedMeal: json['selectedMeal'] ?? '',
      dishId: json['dishId'] ?? '',
      totalCalories: totalCaloriesValue is double ? totalCaloriesValue.round() : totalCaloriesValue,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      servingInfo: ServingInfo.fromJson(json['servingInfo'] ?? {}),
      isCustomFood: json['isCustomFood'] ?? false,
      foodId: json['foodId'] ?? '',
    );
  }
}