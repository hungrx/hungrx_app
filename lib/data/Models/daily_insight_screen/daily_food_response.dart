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
          .toList() ?? [],
    );
  }
}

class FoodItem {
  final int servingSize;
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
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
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
  final int calories;
  final NutrientInfo totalFat;
  final NutrientInfo sodium;
  final NutrientInfo totalCarbohydrates;
  final NutrientInfo sugars;
  final NutrientInfo addedSugars;
  final NutrientInfo protein;

  NutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.sodium,
    required this.totalCarbohydrates,
    required this.sugars,
    required this.addedSugars,
    required this.protein,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: json['calories'] ?? 0,
      totalFat: NutrientInfo.fromJson(json['totalFat'] ?? {}),
      sodium: NutrientInfo.fromJson(json['sodium'] ?? {}),
      totalCarbohydrates: NutrientInfo.fromJson(json['totalCabohydrates'] ?? {}),
      sugars: NutrientInfo.fromJson(json['sugars'] ?? {}),
      addedSugars: NutrientInfo.fromJson(json['addedSugars'] ?? {}),
      protein: NutrientInfo.fromJson(json['protein'] ?? {}),
    );
  }
}

class NutrientInfo {
  final double value;
  final String unit;
  final String? dailyValue;

  NutrientInfo({
    required this.value,
    required this.unit,
    this.dailyValue,
  });

  factory NutrientInfo.fromJson(Map<String, dynamic> json) {
    return NutrientInfo(
      value: (json['value'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'g',
      dailyValue: json['dailyValue'],
    );
  }
}

class ServingInfo {
  final double size;
  final String unit;

  ServingInfo({
    required this.size,
    required this.unit,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: (json['size'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? '',
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