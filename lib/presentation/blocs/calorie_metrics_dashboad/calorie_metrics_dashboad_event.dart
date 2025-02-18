abstract class CalorieMetricsEvent {}

// Remove userId from FetchCalorieMetrics event
class FetchCalorieMetrics extends CalorieMetricsEvent {
  FetchCalorieMetrics(); // No longer needs userId parameter
}
