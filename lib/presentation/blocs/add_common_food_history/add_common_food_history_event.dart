abstract class AddCommonFoodHistoryEvent {}

class AddCommonFoodHistorySubmitted extends AddCommonFoodHistoryEvent {
  final String userId;
  final String dishId;

  AddCommonFoodHistorySubmitted({
    required this.userId,
    required this.dishId,
  });
}