class CommonFoodResponse {
  final bool success;
  final String message;
  final String date;
  final String mealId;
  final Map<String, dynamic> foodDetails;
  final Map<String, dynamic> updatedMeal;
  final double dailyCalories;
  final Map<String, dynamic> updatedCalories;

  CommonFoodResponse({
    required this.success,
    required this.message,
    required this.date,
    required this.mealId,
    required this.foodDetails,
    required this.updatedMeal,
    required this.dailyCalories,
    required this.updatedCalories,
  });

  factory CommonFoodResponse.fromJson(Map<String, dynamic> json) {
    return CommonFoodResponse(
      success: json['success'],
      message: json['message'],
      date: json['date'],
      mealId: json['mealId'],
      foodDetails: json['foodDetails'],
      updatedMeal: json['updatedMeal'],
      dailyCalories: json['dailyCalories'].toDouble(),
      updatedCalories: json['updatedCalories'],
    );
  }
}