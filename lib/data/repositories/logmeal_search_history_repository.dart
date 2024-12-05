import 'package:hungrx_app/data/Models/logmeal_search_history_model.dart';
import 'package:hungrx_app/data/datasources/api/logmeal_search_history_api.dart';

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

      if (response['status'] == true) {
        return LogMealSearchHistoryModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to add to history');
      }
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
