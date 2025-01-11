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
      foods:
          (json['foods'] as List).map((food) => Food.fromJson(food)).toList(),
    );
  }
}

class Food {
  final dynamic servingSize;
  final String selectedMeal;
  final String dishId;
  final double totalCalories;
  final DateTime timestamp;
  final String name;
  final String brandName;
  final String? image;
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
    this.image,
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
      image: json['image'],
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts']),
      servingInfo: ServingInfo.fromJson(json['servingInfo']),
      foodId: json['foodId'],
    );
  }
}

class NutritionFacts {
  final double calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final NutritionValue? sodium;
  final NutritionValue? sugars;
  final NutritionValue? totalFat;
  final NutritionValue? dietaryFiber;
  final NutritionValue? saturatedFat;
  final NutritionValue? totalCarbohydrates;
  final NutritionValue? transFat;
  final NutritionValue? cholesterol;

  NutritionFacts({
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.sodium,
    this.sugars,
    this.totalFat,
    this.dietaryFiber,
    this.saturatedFat,
    this.totalCarbohydrates,
    this.transFat,
    this.cholesterol,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    // Handle null calories
    final calories = json['calories']?.toDouble() ?? 0.0;
    
    // Handle the simplified format
    if ((json.containsKey('protein') && json['protein'] is num) || 
        (json.containsKey('carbs') && json['carbs'] is num)) {
      return NutritionFacts(
        calories: calories,
        protein: json['protein']?.toDouble(),
        carbs: json['carbs']?.toDouble(),
        fat: json['fat']?.toDouble(),
      );
    }
    
    // Handle the detailed format
    return NutritionFacts(
      calories: json['calories'].toDouble(),
      protein: json['protein'] is Map ? 
        (json['protein'] as Map<String, dynamic>)['value']?.toDouble() : 
        null,
      sodium: json['sodium'] != null ? 
        NutritionValue.fromJson(json['sodium']) : 
        null,
      sugars: json['sugars'] != null ? 
        NutritionValue.fromJson(json['sugars']) : 
        null,
      totalFat: json['totalFat'] != null ? 
        NutritionValue.fromJson(json['totalFat']) : 
        null,
      dietaryFiber: json['dietaryFiber'] != null ? 
        NutritionValue.fromJson(json['dietaryFiber']) : 
        null,
      saturatedFat: json['saturatedFat'] != null ? 
        NutritionValue.fromJson(json['saturatedFat']) : 
        null,
      totalCarbohydrates: json['totalCarbohydrates'] != null ? 
        NutritionValue.fromJson(json['totalCarbohydrates']) : 
        null,
      transFat: json['transFat'] != null ? 
        NutritionValue.fromJson(json['transFat']) : 
        null,
      cholesterol: json['cholesterol'] != null ? 
        NutritionValue.fromJson(json['cholesterol']) : 
        null,
    );
  }
}

class NutritionValue {
  final double value;

  NutritionValue({required this.value});

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      value: json['value'].toDouble(),
    );
  }
}

class ServingInfo {
  final String size;
  final String unit;
  final dynamic quantity;
  final Weight? weight;

  ServingInfo({
    required this.size,
    required this.unit,
    this.quantity,
    this.weight,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: json['size']?.toString() ?? '',  // Handle null and convert any type to string
      unit: json['unit'] ?? '',  // Handle null unit
      quantity: json['quantity'],  // Keep as dynamic
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
      unit: json['unit'] ?? 'g',  // Default to 'g' if null
      value: json['vaule']?.toDouble() ?? 0.0,  // Handle null value and convert to double
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
