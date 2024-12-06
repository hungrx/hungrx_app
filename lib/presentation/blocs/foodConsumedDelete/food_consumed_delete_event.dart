abstract class DeleteFoodEvent {}

class DeleteConsumedFoodRequested extends DeleteFoodEvent {
  final String userId;
  final String date;
  final String mealId;
  final String dishId;

  DeleteConsumedFoodRequested({
    required this.userId,
    required this.date,
    required this.mealId,
    required this.dishId,
  });
}