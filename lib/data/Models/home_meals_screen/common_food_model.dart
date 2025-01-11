class CommonFoodModel {
  final String id;
  final String name;
  final String? image;
  final CommonFoodCategory category;
  final CommonFoodServingInfo servingInfo;
  final CommonFoodNutritionFacts nutritionFacts;

  CommonFoodModel({
    required this.id,
    required this.name,
    this.image,
    required this.category,
    required this.servingInfo,
    required this.nutritionFacts,
  });

  factory CommonFoodModel.fromJson(Map<String, dynamic> json) {
    return CommonFoodModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      category: CommonFoodCategory.fromJson(json['category'] as Map<String, dynamic>),
      servingInfo: CommonFoodServingInfo.fromJson(json['servingInfo'] as Map<String, dynamic>),
      nutritionFacts: CommonFoodNutritionFacts.fromJson(json['nutritionFacts'] as Map<String, dynamic>),
    );
  }
}

class CommonFoodCategory {
  final String main;
  final List<String> sub;

  CommonFoodCategory({
    required this.main,
    required this.sub,
  });

  factory CommonFoodCategory.fromJson(Map<String, dynamic> json) {
    return CommonFoodCategory(
      main: json['main'] as String? ?? '', // Add null check
      sub: (json['sub'] as List<dynamic>?)?.map((e) => e as String? ?? '').toList() ?? [], // Add null check
    );
  }
}

class CommonFoodServingInfo {
  final double size;
  final String unit;

  CommonFoodServingInfo({
    required this.size,
    required this.unit,
  });

  factory CommonFoodServingInfo.fromJson(Map<String, dynamic> json) {
    return CommonFoodServingInfo(
      size: (json['size'] ?? 0).toDouble(), // Add null check with default value
      unit: json['unit'] as String? ?? '', // Add null check with empty string default
    );
  }
} 

class NutritionValue {
  final double value;
  final String unit;

  NutritionValue({
    required this.value,
    required this.unit,
  });

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      value: (json['value'] ?? 0).toDouble(), // Add null check with default value
      unit: json['unit'] as String? ?? '', // Add null check with empty string default
    );
  }
}

class CommonFoodNutritionFacts {
  final double calories;
  final NutritionValue totalFat;
  final NutritionValue saturatedFat;
  final NutritionValue cholesterol;
  final NutritionValue sodium;
  final NutritionValue totalCarbohydrate;
  final NutritionValue dietaryFiber;
  final NutritionValue sugars;
  final NutritionValue protein;
  final NutritionValue potassium;

  CommonFoodNutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.saturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrate,
    required this.dietaryFiber,
    required this.sugars,
    required this.protein,
    required this.potassium,
  });

  factory CommonFoodNutritionFacts.fromJson(Map<String, dynamic> json) {
    // Helper function to safely create NutritionValue
    NutritionValue safeNutritionValue(dynamic data) {
      if (data is Map<String, dynamic>) {
        return NutritionValue.fromJson(data);
      }
      return NutritionValue(value: 0, unit: '');
    }

    return CommonFoodNutritionFacts(
      calories: (json['calories'] ?? 0).toDouble(),
      totalFat: safeNutritionValue(json['totalFat']),
      saturatedFat: safeNutritionValue(json['saturatedFat']),
      cholesterol: safeNutritionValue(json['Cholesterol']),
      sodium: safeNutritionValue(json['Sodium']),
      totalCarbohydrate: safeNutritionValue(json['totalCarbohydrate']),
      dietaryFiber: safeNutritionValue(json['DietaryFiber']),
      sugars: safeNutritionValue(json['Sugars']),
      protein: safeNutritionValue(json['Protein']),
      potassium: safeNutritionValue(json['Potassiun']), // Keep the typo handling
    );
  }
}
