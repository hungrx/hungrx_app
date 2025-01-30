abstract class GetBasicInfoEvent {}

// Remove userId from GetBasicInfoRequested event
class GetBasicInfoRequested extends GetBasicInfoEvent {
  GetBasicInfoRequested(); // No longer needs userId parameter
}