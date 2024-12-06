class DeleteFoodRequest {
  final String userId;
  final String date;
  final String mealId;
  final String dishId;

  DeleteFoodRequest({
    required this.userId,
    required this.date,
    required this.mealId,
    required this.dishId,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'date': date,
    'mealId': mealId,
    'dishId': dishId,
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
  final String dailyGoal;
  final double remaining;

  DailySummary({
    required this.totalCalories,
    required this.dailyGoal,
    required this.remaining,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      dailyGoal: json['dailyGoal'] ?? '0',
      remaining: (json['remaining'] ?? 0).toDouble(),
    );
  }
}

class UpdatedCalories {
  final int caloriesToReachGoal;
  final int deletedCalories;

  UpdatedCalories({
    required this.caloriesToReachGoal,
    required this.deletedCalories,
  });

  factory UpdatedCalories.fromJson(Map<String, dynamic> json) {
    return UpdatedCalories(
      caloriesToReachGoal: json['caloriesToReachGoal'] ?? 0,
      deletedCalories: json['deletedCalories'] ?? 0,
    );
  }
}