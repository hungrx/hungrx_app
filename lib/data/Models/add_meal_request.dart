class AddMealRequest {
  final String userId;
  final String mealType;
  final double servingSize;
  final String selectedMeal;
  final String dishId;
  final double totalCalories;

  AddMealRequest({
    required this.userId,
    required this.mealType,
    required this.servingSize,
    required this.selectedMeal,
    required this.dishId,
    required this.totalCalories,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'mealType': mealType,
        'servingSize': servingSize,
        'selectedMeal': selectedMeal,
        'dishId': dishId,
        'totalCalories': totalCalories,
      };
}

class AddMealResponse {
  final bool success;
  final String message;
  final String date;
  final UpdatedCalories updatedCalories;

  AddMealResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.updatedCalories,
  });

  factory AddMealResponse.fromJson(Map<String, dynamic> json) =>
      AddMealResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        date: json['date'] ?? '',
        updatedCalories: json['updatedCalories'] != null
            ? UpdatedCalories.fromJson(json['updatedCalories'])
            : UpdatedCalories(
                remaining: 0,
                consumed: 0,
                caloriesToReachGoal: 0,
              ),
      );
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

  factory UpdatedCalories.fromJson(Map<String, dynamic> json) =>
      UpdatedCalories(
        remaining: json['remaining'] ?? 0,
        consumed: json['consumed'] ?? 0,
        caloriesToReachGoal: json['caloriesToReachGoal'] ?? 0,
      );
}
