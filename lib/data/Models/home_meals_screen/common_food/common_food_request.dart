class CommonFoodRequest {
  final String userId;
  final String mealType;
  final double servingSize;
  final String selectedMeal;
  final String dishId;
  final double totalCalories;

  CommonFoodRequest({
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