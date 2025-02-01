abstract class DeleteFoodEvent {}

class DeleteConsumedFoodRequested extends DeleteFoodEvent {
  final String date;
  final String mealId;
  final String foodId;

  DeleteConsumedFoodRequested({
    required this.date,
    required this.mealId,
    required this.foodId,
  });
}