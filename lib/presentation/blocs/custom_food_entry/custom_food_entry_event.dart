abstract class CustomFoodEntryEvent {}

class CustomFoodEntrySubmitted extends CustomFoodEntryEvent {
  final String userId;
  final String mealType;
  final String foodName;
  final double calories;

  CustomFoodEntrySubmitted({
    required this.userId,
    required this.mealType,
    required this.foodName,
    required this.calories,
  });
}