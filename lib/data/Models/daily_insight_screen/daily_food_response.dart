class DailyFoodResponse {
  final bool success;
  final String message;
  final String date;
  final ConsumedFood consumedFood;
  final DailySummary dailySummary;

  DailyFoodResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.consumedFood,
    required this.dailySummary,
  });

  factory DailyFoodResponse.fromJson(Map<String, dynamic> json) {
    return DailyFoodResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      consumedFood: ConsumedFood.fromJson(json['consumedFood'] ?? {}),
      dailySummary: DailySummary.fromJson(json['dailySummary'] ?? {}),
    );
  }
}

class ConsumedFood {
  final MealData breakfast;
  final MealData lunch;
  final MealData dinner;
  final MealData snacks;

  ConsumedFood({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });

  factory ConsumedFood.fromJson(Map<String, dynamic> json) {
    return ConsumedFood(
      breakfast: MealData.fromJson(json['breakfast'] ?? {}),
      lunch: MealData.fromJson(json['lunch'] ?? {}),
      dinner: MealData.fromJson(json['dinner'] ?? {}),
      snacks: MealData.fromJson(json['snacks'] ?? {}),
    );
  }
}

class MealData {
  final String mealId;
  final List<FoodItem> foods;

  MealData({
    required this.mealId,
    required this.foods,
  });

  factory MealData.fromJson(Map<String, dynamic> json) {
    return MealData(
      mealId: json['mealId'] ?? '',
      foods: (json['foods'] as List<dynamic>?)
              ?.map((food) => FoodItem.fromJson(food))
              .toList() ??
          [],
    );
  }
}

class FoodItem {
  final dynamic servingSize; // Changed to dynamic to handle both int and String
  final String selectedMeal;
  final String dishId;
  final double totalCalories;
  final DateTime timestamp;
  final String name;
  final String? brandName;
  final String? image;
  final NutritionFacts nutritionFacts;
  final ServingInfo? servingInfo;
  final String foodId;
  final bool isCustomFood;

  FoodItem({
    required this.servingSize,
    required this.selectedMeal,
    required this.dishId,
    required this.totalCalories,
    required this.timestamp,
    required this.name,
    this.brandName,
    this.image,
    required this.nutritionFacts,
    this.servingInfo,
    required this.foodId,
    this.isCustomFood = false,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      servingSize: json['servingSize'] ?? 0,
      selectedMeal: json['selectedMeal'] ?? '',
      dishId: json['dishId'] ?? '',
      totalCalories: (json['totalCalories'] ?? 0.0).toDouble(),
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      name: json['name'] ?? '',
      brandName: json['brandName'],
      image: json['image'],
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      servingInfo: json['servingInfo'] != null
          ? ServingInfo.fromJson(json['servingInfo'])
          : null,
      foodId: json['foodId'] ?? '',
      isCustomFood: json['isCustomFood'] ?? false,
    );
  }
}

class NutritionFacts {
  final double calories;
  final dynamic totalFat; // Changed to handle both NutrientInfo and num
  final dynamic sodium;
  final dynamic totalCarbohydrates;
  final dynamic sugars;
  final dynamic protein;
  final dynamic cholesterol;
  final dynamic dietaryFiber;
  final dynamic saturatedFat;
  final dynamic carbs;
  final dynamic fat;

  NutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.sodium,
    required this.totalCarbohydrates,
    required this.sugars,
    required this.protein,
    this.cholesterol,
    this.dietaryFiber,
    this.saturatedFat,
    this.carbs,
    this.fat,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    dynamic getValue(dynamic field) {
      if (field is Map) {
        return (field['value'] ?? 0.0).toDouble();
      }
      return (field ?? 0.0).toDouble();
    }

    return NutritionFacts(
      calories: (json['calories'] ?? 0.0).toDouble(),
      totalFat: getValue(json['totalFat']),
      sodium: getValue(json['sodium']),
      totalCarbohydrates:
          getValue(json['totalCarbohydrates']) ?? getValue(json['carbs']),
      sugars: getValue(json['sugars']),
      protein: getValue(json['protein']),
      cholesterol: getValue(json['cholesterol']),
      dietaryFiber: getValue(json['dietaryFiber']),
      saturatedFat: getValue(json['saturatedFat']),
      carbs: json['carbs'] != null ? (json['carbs'] as num).toDouble() : null,
      fat: json['fat'] != null ? (json['fat'] as num).toDouble() : null,
    );
  }
}

class ServingInfo {
  final dynamic size; // Changed to dynamic to handle both double and String
  final String unit;
  final Weight? weight; // Added weight field

  ServingInfo({
    required this.size,
    required this.unit,
    this.weight,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: json['size'] ?? 0,
      unit: json['unit'] ?? '',
      weight: json['weight'] != null ? Weight.fromJson(json['weight']) : null,
    );
  }
}

class Weight {
  final String unit;
  final double value;

  Weight({
    required this.unit,
    required this.value,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      unit: json['unit'] ?? '',
      value: (json['vaule'] ?? 0.0)
          .toDouble(), // Note: handling typo in JSON 'vaule'
    );
  }
}

class DailySummary {
  final double totalCalories;
  final double dailyGoal;
  final double remaining;

  DailySummary({
    required this.totalCalories,
    required this.dailyGoal,
    required this.remaining,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      totalCalories: (json['totalCalories'] ?? 0.0).toDouble(),
      dailyGoal: double.parse(json['dailyGoal']?.toString() ?? '0'),
      remaining: (json['remaining'] ?? 0.0).toDouble(),
    );
  }
}
