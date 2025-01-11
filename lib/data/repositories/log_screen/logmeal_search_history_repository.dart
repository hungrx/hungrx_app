import 'package:hungrx_app/data/Models/home_meals_screen/logmeal_search_history_model.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/logmeal_search_history_api.dart';

class LogMealSearchHistoryRepository {
  final LogMealSearchHistoryApi _api;

  LogMealSearchHistoryRepository(this._api);

  Future<LogMealSearchHistoryModel> addToHistory({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _api.addToHistory(
        userId: userId,
        productId: productId,
      );
      if (response['status'] == true && response['data'] != null) {
        return LogMealSearchHistoryModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to add to history: Invalid response format');
      }
    } catch (e) {
      // print('Repository error details: $e');
      if (e is FormatException) {
        throw Exception('Repository error: Invalid data format');
      } else if (e is TypeError) {
        throw Exception('Repository error: Unexpected data type in response');
      }
      throw Exception('Repository error: ${e.toString()}');
    }
  }
}
