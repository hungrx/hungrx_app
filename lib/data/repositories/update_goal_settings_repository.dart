import 'package:hungrx_app/data/Models/update_goal_settings_model.dart';
import 'package:hungrx_app/data/datasources/api/update_goal_settings_api.dart';

class UpdateGoalSettingsRepository {
  final UpdateGoalSettingsApi _api;

  UpdateGoalSettingsRepository({required UpdateGoalSettingsApi api}) : _api = api;

  Future<UpdateGoalSettingsModel> updateGoalSettings(UpdateGoalSettingsModel settings) async {
    try {
      final response = await _api.updateGoalSettings(settings);
      if (response['status'] == true) {
        return UpdateGoalSettingsModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update goal settings');
      }
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}