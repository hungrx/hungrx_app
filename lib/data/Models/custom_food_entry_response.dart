class CustomFoodEntryResponse {
  final bool success;
  final String message;
  final String date;
  final UpdatedCalories updatedCalories;
  final FoodDetails foodDetails;

  CustomFoodEntryResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.updatedCalories,
    required this.foodDetails,
  });

  factory CustomFoodEntryResponse.fromJson(Map<String, dynamic> json) {
    return CustomFoodEntryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      updatedCalories: UpdatedCalories.fromJson(json['updatedCalories'] ?? {}),
      foodDetails: FoodDetails.fromJson(json['foodDetails'] ?? {}),
    );
  }
}

class UpdatedCalories {
  final int remaining;
  final int consumed;
  final int caloriesToReachGoal;

  UpdatedCalories({
    required this.remaining,
    required this.consumed,
    required this.caloriesToReachGoal,
  });

  factory UpdatedCalories.fromJson(Map<String, dynamic> json) {
    return UpdatedCalories(
      remaining: json['remaining'] ?? 0,
      consumed: json['consumed'] ?? 0,
      caloriesToReachGoal: json['caloriesToReachGoal'] ?? 0,
    );
  }
}

class FoodDetails {
  final String name;
  final String mealType;
  final String mealId;
  final int calories;

  FoodDetails({
    required this.name,
    required this.mealType,
    required this.mealId,
    required this.calories,
  });

  factory FoodDetails.fromJson(Map<String, dynamic> json) {
    return FoodDetails(
      name: json['name'] ?? '',
      mealType: json['mealType'] ?? '',
      mealId: json['mealId'] ?? '',
      calories: json['calories'] ?? 0,
    );
  }
}