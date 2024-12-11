import 'package:hungrx_app/data/Models/goal_settings_model.dart';
import 'package:hungrx_app/data/repositories/goal_settings_repository.dart';

class GetGoalSettingsUseCase {
  final GoalSettingsRepository _repository;

  GetGoalSettingsUseCase(this._repository);

  Future<GoalSettingsModel> execute(String userId) {
    return _repository.getGoalSettings(userId);
  }
}