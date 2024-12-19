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

  factory AddMealResponse.fromJson(Map<String, dynamic> json) => AddMealResponse(
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

  factory UpdatedCalories.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert values to double
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return UpdatedCalories(
      remaining: toDouble(json['remaining']),
      consumed: toDouble(json['consumed']),
      caloriesToReachGoal: toDouble(json['caloriesToReachGoal']),
    );
  }
}