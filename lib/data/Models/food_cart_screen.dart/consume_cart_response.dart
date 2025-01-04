class ConsumeCartResponse {
  final bool status;
  final String message;
  final String date;
  final UpdatedMeal updatedMeal;
  final double dailyCalories;
  final UpdatedCalories updatedCalories;

  ConsumeCartResponse({
    required this.status,
    required this.message,
    required this.date,
    required this.updatedMeal,
    required this.dailyCalories,
    required this.updatedCalories,
  });

  factory ConsumeCartResponse.fromJson(Map<String, dynamic> json) {
    return ConsumeCartResponse(
      status: json['status'],
      message: json['message'],
      date: json['date'],
      updatedMeal: UpdatedMeal.fromJson(json['updatedMeal']),
      dailyCalories: json['dailyCalories'].toDouble(),
      updatedCalories: UpdatedCalories.fromJson(json['updatedCalories']),
    );
  }
}

class UpdatedMeal {
  final String mealId;
  final List<Food> foods;

  UpdatedMeal({required this.mealId, required this.foods});

  factory UpdatedMeal.fromJson(Map<String, dynamic> json) {
    return UpdatedMeal(
      mealId: json['mealId'],
      foods: (json['foods'] as List).map((food) => Food.fromJson(food)).toList(),
    );
  }
}

class Food {
  final String servingSize;
  final String selectedMeal;
  final String dishId;
  final double totalCalories;
  final DateTime timestamp;
  final String name;
  final String brandName;
  final NutritionFacts nutritionFacts;
  final ServingInfo servingInfo;
  final String foodId;

  Food({
    required this.servingSize,
    required this.selectedMeal,
    required this.dishId,
    required this.totalCalories,
    required this.timestamp,
    required this.name,
    required this.brandName,
    required this.nutritionFacts,
    required this.servingInfo,
    required this.foodId,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      servingSize: json['servingSize'],
      selectedMeal: json['selectedMeal'],
      dishId: json['dishId'],
      totalCalories: json['totalCalories'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      name: json['name'],
      brandName: json['brandName'],
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts']),
      servingInfo: ServingInfo.fromJson(json['servingInfo']),
      foodId: json['foodId'],
    );
  }
}

class NutritionFacts {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  NutritionFacts({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: json['calories'].toDouble(),
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
    );
  }
}

class ServingInfo {
  final String size;
  final String unit;
  final int quantity;

  ServingInfo({
    required this.size,
    required this.unit,
    required this.quantity,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: json['size'],
      unit: json['unit'],
      quantity: json['quantity'],
    );
  }
}

class UpdatedCalories {
  final double remaining;
  final double consumed;
  final double caloriesToReachGoal;

  UpdatedCalories({
    required this.remaining,
    required this.consumed,
    required this.caloriesToReachGoal,
  });

  factory UpdatedCalories.fromJson(Map<String, dynamic> json) {
    return UpdatedCalories(
      remaining: json['remaining'].toDouble(),
      consumed: json['consumed'].toDouble(),
      caloriesToReachGoal: json['caloriesToReachGoal'].toDouble(),
    );
  }
}