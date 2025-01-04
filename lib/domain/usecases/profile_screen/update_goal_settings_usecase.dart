import 'package:hungrx_app/data/Models/profile_screen/update_goal_settings_model.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/update_goal_settings_repository.dart';

class UpdateGoalSettingsUseCase {
  final UpdateGoalSettingsRepository _repository;

  UpdateGoalSettingsUseCase({required UpdateGoalSettingsRepository repository})
      : _repository = repository;

  Future<UpdateGoalSettingsModel> execute(UpdateGoalSettingsModel settings) {
    return _repository.updateGoalSettings(settings);
  }
}