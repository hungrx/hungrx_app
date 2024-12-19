import 'package:hungrx_app/data/Models/home_meals_screen/get_search_history_log_response.dart';
import 'package:hungrx_app/data/repositories/search_history_log_repository.dart';

class GetSearchHistoryLogUseCase {
  final SearchHistoryLogRepository repository;

  GetSearchHistoryLogUseCase({required this.repository});

  Future<List<GetSearchHistoryLogItem>> execute(String userId) async {
    try {
      final response = await repository.getSearchHistory(userId);
      return response.data;
    } catch (e) {
      // print(e);
      throw Exception('UseCase error: $e');
    }
  }
}