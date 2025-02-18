abstract class TimezoneEvent {}

class UpdateUserTimezone extends TimezoneEvent {
  final String userId;
  UpdateUserTimezone(this.userId);
}