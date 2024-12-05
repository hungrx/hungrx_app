import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/feedback_model.dart';


class FeedbackApiService {
  // final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.feedback),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedback.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to submit feedback: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting feedback: $e');
    }
  }
}