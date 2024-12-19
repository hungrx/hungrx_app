import 'package:hungrx_app/data/Models/dashboad_screen/feedback_model.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/feedback_repository.dart';

class SubmitFeedbackUseCase {
  final FeedbackRepository _repository;

  SubmitFeedbackUseCase(this._repository);

  Future<bool> execute(FeedbackModel feedback) async {
    try {
      return await _repository.submitFeedback(feedback);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}