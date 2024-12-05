import 'package:hungrx_app/data/Models/get_search_history_log_response.dart';
import 'package:hungrx_app/data/datasources/api/get_search_history_log_api.dart';

class SearchHistoryLogRepository {
  final GetSearchHistoryLogApi api;

  SearchHistoryLogRepository({required this.api});

  Future<GetSearchHistoryLogResponse> getSearchHistory(String userId) async {
    try {
      return await api.getSearchHistory(userId);
    } catch (e) {
      // print(e);
      throw Exception('Repository error: $e');
    }
  }
}