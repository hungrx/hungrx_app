class AddCommonFoodHistoryRequest {
  final String userId;
  final String dishId;

  AddCommonFoodHistoryRequest({
    required this.userId,
    required this.dishId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'dishId': dishId,
      };
}

class AddCommonFoodHistoryResponse {
  final bool status;
  final String message;
  final AddCommonFoodHistoryData data;

  AddCommonFoodHistoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddCommonFoodHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AddCommonFoodHistoryResponse(
      status: json['status'],
      message: json['message'],
      data: AddCommonFoodHistoryData.fromJson(json['data']),
    );
  }
}

class AddCommonFoodHistoryData {
  final String foodId;
  final String name;
  final String brandName;
  final String? image;  // Made nullable
  final NutritionFacts nutritionFacts;
  final ServingInfo servingInfo;
  final Category category;
  final String viewedAt;
  final String searchDate;
  final String searchTime;

  AddCommonFoodHistoryData({
    required this.foodId,
    required this.name,
    required this.brandName,
    this.image,  // Remove required keyword
    required this.nutritionFacts,
    required this.servingInfo,
    required this.category,
    required this.viewedAt,
    required this.searchDate,
    required this.searchTime,
  });

  factory AddCommonFoodHistoryData.fromJson(Map<String, dynamic> json) {
    return AddCommonFoodHistoryData(
      foodId: json['foodId'],
      name: json['name'],
      brandName: json['brandName'],
      image: json['image'],  // Will automatically handle null
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts']),
      servingInfo: ServingInfo.fromJson(json['servingInfo']),
      category: Category.fromJson(json['category']),
      viewedAt: json['viewedAt'],
      searchDate: json['searchDate'],
      searchTime: json['searchTime'],
    );
  }
}

class NutritionFacts {
  final double calories;
  final NutrientInfo totalFat;
  final NutrientInfo saturatedFat;
  final NutrientInfo cholesterol;
  final NutrientInfo sodium;
  final NutrientInfo totalCarbohydrate;
  final NutrientInfo dietaryFiber;
  final NutrientInfo sugars;
  final NutrientInfo protein;
  final NutrientInfo potassiun;

  NutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.saturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrate,
    required this.dietaryFiber,
    required this.sugars,
    required this.protein,
    required this.potassiun,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: json['calories'].toDouble(),
      totalFat: NutrientInfo.fromJson(json['totalFat']),
      saturatedFat: NutrientInfo.fromJson(json['saturatedFat']),
      cholesterol: NutrientInfo.fromJson(json['Cholesterol']),
      sodium: NutrientInfo.fromJson(json['Sodium']),
      totalCarbohydrate: NutrientInfo.fromJson(json['totalCarbohydrate']),
      dietaryFiber: NutrientInfo.fromJson(json['DietaryFiber']),
      sugars: NutrientInfo.fromJson(json['Sugars']),
      protein: NutrientInfo.fromJson(json['Protein']),
      potassiun: NutrientInfo.fromJson(json['Potassiun']),
    );
  }
}

class NutrientInfo {
  final double value;
  final String unit;

  NutrientInfo({
    required this.value,
    required this.unit,
  });

  factory NutrientInfo.fromJson(Map<String, dynamic> json) {
    return NutrientInfo(
      value: json['value'].toDouble(),
      unit: json['unit'],
    );
  }
}

class ServingInfo {
  final double size;  // Changed from int to double
  final String unit;

  ServingInfo({
    required this.size,
    required this.unit,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: json['size'].toDouble(),  // Convert to double
      unit: json['unit'],
    );
  }
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
      main: json['main'],
      sub: List<String>.from(json['sub']),
    );
  }
}