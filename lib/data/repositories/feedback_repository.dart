import 'package:hungrx_app/data/Models/feedback_model.dart';
import 'package:hungrx_app/data/datasources/api/feedback_api_service.dart';

class FeedbackRepository {
  final FeedbackApiService _apiService;

  FeedbackRepository(this._apiService);

  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      return await _apiService.submitFeedback(feedback);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}