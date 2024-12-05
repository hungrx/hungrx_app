abstract class LogMealSearchHistoryEvent {}

class AddToLogMealSearchHistory extends LogMealSearchHistoryEvent {
  final String userId;
  final String productId;

  AddToLogMealSearchHistory({
    required this.userId,
    required this.productId,
  });
}