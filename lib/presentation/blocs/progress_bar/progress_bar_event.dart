// Modified Event classes
abstract class ProgressBarEvent {}

// Remove userId from FetchProgressBarData event
class FetchProgressBarData extends ProgressBarEvent {
  FetchProgressBarData(); // No longer needs userId parameter
}