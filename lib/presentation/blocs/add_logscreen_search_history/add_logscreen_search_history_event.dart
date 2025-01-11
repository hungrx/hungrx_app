abstract class LogMealSearchHistoryEvent {}

class AddToLogMealSearchHistory extends LogMealSearchHistoryEvent {
  final String productId;

  AddToLogMealSearchHistory({
    required this.productId,
  });
}