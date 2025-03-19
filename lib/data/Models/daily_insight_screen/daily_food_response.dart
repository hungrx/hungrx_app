

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
  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'date': date,
    'consumedFood': consumedFood.toJson(),
    'dailySummary': dailySummary.toJson(),
  };
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
  Map<String, dynamic> toJson() => {
    'breakfast': breakfast.toJson(),
    'lunch': lunch.toJson(),
    'dinner': dinner.toJson(),
    'snacks': snacks.toJson(),
  };
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
  Map<String, dynamic> toJson() => {
    'mealId': mealId,
    'foods': foods.map((food) => food.toJson()).toList(),
  };
}

class FoodItem {
  final dynamic servingSize;
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
  final Category? category; // Added field

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
    this.category, // Added parameter
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
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }
  Map<String, dynamic> toJson() => {
    'servingSize': servingSize,
    'selectedMeal': selectedMeal,
    'dishId': dishId,
    'totalCalories': totalCalories,
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'brandName': brandName,
    'image': image,
    'nutritionFacts': nutritionFacts.toJson(),
    'servingInfo': servingInfo?.toJson(),
    'foodId': foodId,
    'isCustomFood': isCustomFood,
    // 'category': category?.toJson(),
  };
}

class Category {
  final String main;
  final List<String> sub;

  Category({
    required this.main,
    required this.sub,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      main: json['main'] ?? '',
      sub: (json['sub'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class NutrientInfo {
  final double value;
  final String? unit;

  NutrientInfo({
    required this.value,
    this.unit,
  });

  factory NutrientInfo.fromJson(Map<String, dynamic> json) {
    return NutrientInfo(
      value: (json['value'] ?? 0.0).toDouble(),
      unit: json['unit'],
    );
  }
   Map<String, dynamic> toJson() => {
    'value': value,
    'unit': unit,
  };
}


class NutritionFacts {
  final double calories;
  final NutrientInfo? totalFat;
  final NutrientInfo? sodium;
  final NutrientInfo? totalCarbohydrates;
  final NutrientInfo? sugars;
  final NutrientInfo? protein;
  final NutrientInfo? cholesterol;
  final NutrientInfo? dietaryFiber;
  final NutrientInfo? saturatedFat;
  final NutrientInfo? transFat;  // Added field
  final dynamic carbs;
  final dynamic fat;
  final NutrientInfo? totalCarbohydrate;  // Added field
  final NutrientInfo? potassiun;  // Added field (keeping original typo)

  NutritionFacts({
    required this.calories,
    this.totalFat,
    this.sodium,
    this.totalCarbohydrates,
    this.sugars,
    this.protein,
    this.cholesterol,
    this.dietaryFiber,
    this.saturatedFat,
    this.transFat,  // Added
    this.carbs,
    this.fat,
    this.totalCarbohydrate,  // Added
    this.potassiun,  // Added
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    NutrientInfo? parseNutrientInfo(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return NutrientInfo.fromJson(value);
      }
      return NutrientInfo(value: value.toDouble());
    }

    return NutritionFacts(
      calories: (json['calories'] ?? 0.0).toDouble(),
      totalFat: parseNutrientInfo(json['totalFat']),
      sodium: parseNutrientInfo(json['sodium']),
      totalCarbohydrates: parseNutrientInfo(json['totalCarbohydrates']),
      totalCarbohydrate: parseNutrientInfo(json['totalCarbohydrate']),
      sugars: parseNutrientInfo(json['sugars']),
      protein: parseNutrientInfo(json['protein']),
      cholesterol: parseNutrientInfo(json['cholesterol'] ?? json['Cholesterol']),
      dietaryFiber: parseNutrientInfo(json['dietaryFiber'] ?? json['DietaryFiber']),
      saturatedFat: parseNutrientInfo(json['saturatedFat']),
      transFat: parseNutrientInfo(json['transFat']),
      potassiun: parseNutrientInfo(json['Potassiun']),
      carbs: json['carbs'],
      fat: json['fat'],
    );
  }
  Map<String, dynamic> toJson() => {
    'calories': calories,
    'totalFat': totalFat?.toJson(),
    'sodium': sodium?.toJson(),
    'totalCarbohydrates': totalCarbohydrates?.toJson(),
    'sugars': sugars?.toJson(),
    'protein': protein?.toJson(),
    'cholesterol': cholesterol?.toJson(),
    'dietaryFiber': dietaryFiber?.toJson(),
    'saturatedFat': saturatedFat?.toJson(),
    'transFat': transFat?.toJson(),
    'carbs': carbs,
    'fat': fat,
    'totalCarbohydrate': totalCarbohydrate?.toJson(),
    'Potassiun': potassiun?.toJson(),
  };
}

class ServingInfo {
  final dynamic size; // Changed to dynamic to handle both double and String
  final String unit;
  final Weight? weight; // Added weight field
  final int quantity; // Add

  ServingInfo({
    required this.size,
    required this.unit,
    this.weight,
    required this.quantity, // Added as required
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: json['size'] ?? 0,
      unit: json['unit'] ?? '',
      weight: json['weight'] != null ? Weight.fromJson(json['weight']) : null,
      quantity: json['quantity'] ?? 1, // Added with default value
    );
  }
   Map<String, dynamic> toJson() => {
    'size': size,
    'unit': unit,
    'weight': weight?.toJson(),
    'quantity': quantity,
  };
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
  Map<String, dynamic> toJson() => {
    'unit': unit,
    'vaule': value, // Keeping the typo as per original
  };
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
  Map<String, dynamic> toJson() => {
    'totalCalories': totalCalories,
    'dailyGoal': dailyGoal,
    'remaining': remaining,
  };
}
