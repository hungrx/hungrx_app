abstract class DeleteWaterEvent {}

// Remove userId from DeleteWaterIntakeEntry event
class DeleteWaterIntakeEntry extends DeleteWaterEvent {
  final String date;
  final String entryId;

  DeleteWaterIntakeEntry({
    required this.date,
    required this.entryId,
  }); // Removed userId parameter
}