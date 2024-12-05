// Base response model
class ApiResponse<T> {
  final bool status;
  final int count;
  final List<T> data;

  ApiResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse(
      status: json['status'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
              ?.map((item) => fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class FoodItemModel {
  final String id;
  final String itemId;
  final String name;
  final String? image;
  final String? brand;
  final String? calorieBurnNote;
  final CategoryInfo? category;
  final NutritionFacts nutritionFacts;
  final ServingInfo? servingInfo;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int searchScore;

  FoodItemModel({
    required this.id,
    required this.itemId,
    required this.name,
    this.image,
    this.brand,
    this.calorieBurnNote,
    this.category,
    required this.nutritionFacts,
    this.servingInfo,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    required this.searchScore,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['_id'] ?? '',
      itemId: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      brand: json['brandName']??'unknown',
      calorieBurnNote: json['calorieBurnNote'],
      category: json['category'] != null
          ? CategoryInfo.fromJson(json['category'])
          : null,
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      servingInfo: json['servingInfo'] != null
          ? ServingInfo.fromJson(json['servingInfo'])
          : null,
      source: json['source'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      searchScore: json['searchScore'] ?? 0,
    );
  }
}

class CategoryInfo {
  final String main;
  final List<String> sub;

  CategoryInfo({
    required this.main,
    required this.sub,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      main: json['main'] ?? '',
      sub: (json['sub'] as List?)?.map((e) => e.toString()).toList() ?? [],
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
      size: (json['size'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}

class NutritionFacts {
  final double calories;
  final NutrientValue? totalFat;
  final NutrientValue? saturatedFat;
  final NutrientValue? cholesterol;
  final NutrientValue? sodium;
  final NutrientValue? totalCarbohydrates;
  final NutrientValue? dietaryFiber;
  final NutrientValue? sugars;
  final NutrientValue? addedSugars;
  final NutrientValue? protein;
  final NutrientValue? potassium;

  NutritionFacts({
    required this.calories,
    this.totalFat,
    this.saturatedFat,
    this.cholesterol,
    this.sodium,
    this.totalCarbohydrates,
    this.dietaryFiber,
    this.sugars,
    this.addedSugars,
    this.protein,
    this.potassium,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: (json['calories'] ?? 0).toDouble(),
      totalFat: _getNutrientValue(json['totalFat']),
      saturatedFat: _getNutrientValue(json['saturatedFat']),
      cholesterol: _getNutrientValue(json['Cholesterol']),
      sodium: _getNutrientValue(json['sodium'] ?? json['Sodium']),
      totalCarbohydrates:
          _getNutrientValue(json['totalCarbohydrates'] ?? json['totalCarbohydrate']),
      dietaryFiber: _getNutrientValue(json['DietaryFiber']),
      sugars: _getNutrientValue(json['sugars'] ?? json['Sugars']),
      addedSugars: _getNutrientValue(json['addedSugars']),
      protein: _getNutrientValue(json['protein'] ?? json['Protein']),
      potassium: _getNutrientValue(json['Potassiun']), // Note: Handling typo in API
    );
  }

  static NutrientValue? _getNutrientValue(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) {
      return NutrientValue.fromJson(json);
    }
    // Handle case where value is directly provided without unit
    return NutrientValue(value: (json).toDouble(), unit: 'g');
  }
}

class NutrientValue {
  final double value;
  final String unit;

  NutrientValue({
    required this.value,
    required this.unit,
  });

  factory NutrientValue.fromJson(Map<String, dynamic> json) {
    return NutrientValue(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'g',
    );
  }
}