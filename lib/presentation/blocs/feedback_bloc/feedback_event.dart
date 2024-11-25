abstract class FeedbackEvent {}

class SubmitFeedbackEvent extends FeedbackEvent {
  final double rating;
  final String description;

  SubmitFeedbackEvent({required this.rating, required this.description});
}