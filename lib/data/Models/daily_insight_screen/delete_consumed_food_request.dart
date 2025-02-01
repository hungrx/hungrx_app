class DeleteFoodRequest {
  final String userId;
  final String date;
  final String mealId;
  final String foodId;

  DeleteFoodRequest({
    required this.userId,
    required this.date,
    required this.mealId,
    required this.foodId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'date': date,
        'mealId': mealId,
        'foodId': foodId,
      };
}

class DeleteFoodResponse {
  final bool success;
  final String message;
  final String date;
  final String mealId;
  final String mealType;
  final UpdatedMeal updatedMeal;
  final DailySummary dailySummary;
  final UpdatedCalories updatedCalories;

  DeleteFoodResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.mealId,
    required this.mealType,
    required this.updatedMeal,
    required this.dailySummary,
    required this.updatedCalories,
  });

  factory DeleteFoodResponse.fromJson(Map<String, dynamic> json) {
    return DeleteFoodResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      mealId: json['mealId'] ?? '',
      mealType: json['mealType'] ?? '',
      updatedMeal: UpdatedMeal.fromJson(json['updatedMeal'] ?? {}),
      dailySummary: DailySummary.fromJson(json['dailySummary'] ?? {}),
      updatedCalories: UpdatedCalories.fromJson(json['updatedCalories'] ?? {}),
    );
  }
}

class UpdatedMeal {
  final String mealId;
  final List<dynamic> foods;

  UpdatedMeal({required this.mealId, required this.foods});

  factory UpdatedMeal.fromJson(Map<String, dynamic> json) {
    return UpdatedMeal(
      mealId: json['mealId'] ?? '',
      foods: json['foods'] ?? [],
    );
  }
}

class DailySummary {
  final double totalCalories;
  final double dailyGoal; // Changed from String to double
  final double remaining;

  DailySummary({
    required this.totalCalories,
    required this.dailyGoal,
    required this.remaining,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      dailyGoal:
          double.parse(json['dailyGoal'] ?? '0'), // Parse string to double
      remaining: (json['remaining'] ?? 0).toDouble(),
    );
  }
}

class UpdatedCalories {
  final double caloriesToReachGoal; // Changed from int to double
  final double deletedCalories; // Changed from int to double

  UpdatedCalories({
    required this.caloriesToReachGoal,
    required this.deletedCalories,
  });

  factory UpdatedCalories.fromJson(Map<String, dynamic> json) {
    return UpdatedCalories(
      caloriesToReachGoal: (json['caloriesToReachGoal'] ?? 0).toDouble(),
      deletedCalories: (json['deletedCalories'] ?? 0).toDouble(),
    );
  }
}
