abstract class TDEEEvent {}

class CalculateTDEE extends TDEEEvent {
  final String userId;
  
  CalculateTDEE(this.userId);
}