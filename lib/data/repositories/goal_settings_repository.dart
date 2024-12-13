import 'package:hungrx_app/data/Models/goal_settings_model.dart';
import 'package:hungrx_app/data/datasources/api/goal_settings_api.dart';

class GoalSettingsRepository {
  final GoalSettingsApi _api;

  GoalSettingsRepository(this._api);

  Future<GoalSettingsModel> getGoalSettings(String userId) async {
    try {
      final data = await _api.fetchGoalSettings(userId);
      return GoalSettingsModel.fromJson(data);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}