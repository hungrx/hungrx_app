import 'package:hungrx_app/data/Models/streak_data_model.dart';
import 'package:hungrx_app/data/datasources/api/streak_api_service.dart';

class StreakRepository {
  final StreakApiService _apiService;

  StreakRepository(this._apiService);

  Future<StreakDataModel> getUserStreak(String userId) async {
    try {
      final response = await _apiService.fetchUserStreak(userId);
      return StreakDataModel.fromJson(response);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}