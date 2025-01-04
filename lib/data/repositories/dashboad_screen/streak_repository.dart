import 'package:hungrx_app/data/Models/dashboad_screen/streak_data_model.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/streak_api_service.dart';

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