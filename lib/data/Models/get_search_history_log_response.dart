// lib/data/models/get_search_history_log/get_search_history_log_response.dart
class GetSearchHistoryLogResponse {
  final bool status;
  final int count;
  final List<GetSearchHistoryLogItem> data;

  GetSearchHistoryLogResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory GetSearchHistoryLogResponse.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogResponse(
      status: json['status'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => GetSearchHistoryLogItem.fromJson(item))
          .toList() ?? [],
    );
  }
}

// lib/data/models/get_search_history_log/get_search_history_log_item.dart
class GetSearchHistoryLogItem {
  final String foodId;  // Changed from id
  final String name;    // Moved from foodItem
  final String brandName; // Moved from foodItem
  final String image;   // Moved from foodItem
  final GetSearchHistoryLogNutritionFacts nutritionFacts;
  final GetSearchHistoryLogServingInfo servingInfo;
  final DateTime viewedAt;
  final String searchDate;  // Added
  final String searchTime;  // Added

  GetSearchHistoryLogItem({
    required this.foodId,
    required this.name,
    required this.brandName,
    required this.image,
    required this.nutritionFacts,
    required this.servingInfo,
    required this.viewedAt,
    required this.searchDate,
    required this.searchTime,
  });

  factory GetSearchHistoryLogItem.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogItem(
      foodId: json['foodId'] ?? '',
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      image: json['image'] ?? '',
      nutritionFacts: GetSearchHistoryLogNutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      servingInfo: GetSearchHistoryLogServingInfo.fromJson(json['servingInfo'] ?? {}),
      viewedAt: DateTime.parse(json['viewedAt'] ?? DateTime.now().toIso8601String()),
      searchDate: json['searchDate'] ?? '',
      searchTime: json['searchTime'] ?? '',
    );
  }
}


// lib/data/models/get_search_history_log/get_search_history_log_food_item.dart
class GetSearchHistoryLogFoodItem {
  final String id;
  final String name;
  final String brandName;
  final String image;
  final GetSearchHistoryLogNutritionFacts nutritionFacts;
  final GetSearchHistoryLogServingInfo servingInfo;

  GetSearchHistoryLogFoodItem({
    required this.id,
    required this.name,
    required this.brandName,
    required this.image,
    required this.nutritionFacts,
    required this.servingInfo,
  });
// !change product id
  factory GetSearchHistoryLogFoodItem.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogFoodItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      image: json['image'] ?? '',
      nutritionFacts: GetSearchHistoryLogNutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      servingInfo: GetSearchHistoryLogServingInfo.fromJson(json['servingInfo'] ?? {}),
    );
  }
}

// lib/data/models/get_search_history_log/get_search_history_log_nutrition_facts.dart
class GetSearchHistoryLogNutritionFacts {
  final double? calories;
  final GetSearchHistoryLogNutrientInfo? totalFat;
  final GetSearchHistoryLogNutrientInfo? sodium;
  final GetSearchHistoryLogNutrientInfo? totalCarbohydrates;
  final GetSearchHistoryLogNutrientInfo? sugars;
  final GetSearchHistoryLogNutrientInfo? addedSugars;
  final GetSearchHistoryLogNutrientInfo? protein;
  final GetSearchHistoryLogNutrientInfo? saturatedFat;
  final GetSearchHistoryLogNutrientInfo? cholesterol;
  final GetSearchHistoryLogNutrientInfo? dietaryFiber;
  final GetSearchHistoryLogNutrientInfo? potassium;

  GetSearchHistoryLogNutritionFacts({
    this.calories,
    this.totalFat,
    this.sodium,
    this.totalCarbohydrates,
    this.sugars,
    this.addedSugars,
    this.protein,
    this.saturatedFat,
    this.cholesterol,
    this.dietaryFiber,
    this.potassium,
  });

  factory GetSearchHistoryLogNutritionFacts.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogNutritionFacts(
      calories: double.tryParse(json['calories']?.toString() ?? ''),
      totalFat: json['totalFat'] != null 
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['totalFat'])
          : null,
      sodium: json['sodium'] != null 
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['sodium'])
          : null,
      totalCarbohydrates: json['totalCarbohydrate'] != null  // Changed from totalCarbohydrates
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['totalCarbohydrate'])
          : null,
      sugars: json['Sugars'] != null  // Changed case
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['Sugars'])
          : null,
      addedSugars: json['addedSugars'] != null
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['addedSugars'])
          : null,
      protein: json['Protein'] != null  // Changed case
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['Protein'])
          : null,
      saturatedFat: json['saturatedFat'] != null
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['saturatedFat'])
          : null,
      cholesterol: json['Cholesterol'] != null
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['Cholesterol'])
          : null,
      dietaryFiber: json['DietaryFiber'] != null
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['DietaryFiber'])
          : null,
      potassium: json['Potassiun'] != null  // Keep the typo as it's in the API
          ? GetSearchHistoryLogNutrientInfo.fromJson(json['Potassiun'])
          : null,
    );
  }
}

// lib/data/models/get_search_history_log/get_search_history_log_nutrient_info.dart
class GetSearchHistoryLogNutrientInfo {
  final double? value;
  final String? unit;
  final String? dailyValue;

  GetSearchHistoryLogNutrientInfo({
    this.value,
    this.unit,
    this.dailyValue,
  });

  factory GetSearchHistoryLogNutrientInfo.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogNutrientInfo(
      value: double.tryParse(json['value']?.toString() ?? ''),
      unit: json['unit']?.toString(),
      dailyValue: json['dailyValue']?.toString(),
    );
    }
}

// lib/data/models/get_search_history_log/get_search_history_log_serving_info.dart
class GetSearchHistoryLogServingInfo {
  final double? size;
  final String? unit;
  final GetSearchHistoryLogWeight? weight;

  GetSearchHistoryLogServingInfo({
    this.size,
    this.unit,
    this.weight,
  });

  factory GetSearchHistoryLogServingInfo.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogServingInfo(
      size: double.tryParse(json['size']?.toString() ?? ''),
      unit: json['unit']?.toString(),
      weight: json['weight'] != null
          ? GetSearchHistoryLogWeight.fromJson(json['weight'])
          : null,
    );
  }
}
// lib/data/models/get_search_history_log/get_search_history_log_weight.dart
class GetSearchHistoryLogWeight {
  final double? value;
  final String? unit;

  GetSearchHistoryLogWeight({
    this.value,
    this.unit,
  });

  factory GetSearchHistoryLogWeight.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogWeight(
      value: double.tryParse(json['value']?.toString() ?? ''),
      unit: json['unit']?.toString(),
    );
  }
}

// lib/data/models/get_search_history_log/get_search_history_log_search_info.dart
class GetSearchHistoryLogSearchInfo {
  final String date;
  final String time;
  final DateTime timestamp;

  GetSearchHistoryLogSearchInfo({
    required this.date,
    required this.time,
    required this.timestamp,
  });

  factory GetSearchHistoryLogSearchInfo.fromJson(Map<String, dynamic> json) {
    return GetSearchHistoryLogSearchInfo(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}