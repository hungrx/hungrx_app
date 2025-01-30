import 'package:hungrx_app/data/Models/profile_screen/update_goal_settings_model.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/update_goal_settings_api.dart';

class UpdateGoalSettingsRepository {
  final UpdateGoalSettingsApi _api;

  UpdateGoalSettingsRepository({required UpdateGoalSettingsApi api}) : _api = api;

  Future<UpdateGoalSettingsModel> updateGoalSettings(UpdateGoalSettingsModel settings) async {
    try {
      final response = await _api.updateGoalSettings(settings);
      print(response);
      if (response['status'] == true) {
        return UpdateGoalSettingsModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update goal settings');
      }
    } catch (e) {
      print(e);
      throw Exception('Repository error: $e');
    }
  }
}