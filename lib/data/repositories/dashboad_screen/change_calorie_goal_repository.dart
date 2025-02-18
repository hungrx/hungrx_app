import 'package:hungrx_app/data/Models/dashboad_screen/change_calorie_goal_model.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/change_calorie_goal_api.dart';

class ChangeCalorieGoalRepository {
  final ChangeCalorieGoalApi _api;

  ChangeCalorieGoalRepository(this._api);

  Future<ChangeCalorieGoalModel> changeCalorieGoal({
    required String userId,
    required double calorie,
    required int day,
    required bool isShown,
    required String date,
  }) async {
    try {
      final response = await _api.changeCalorieGoal(
        userId: userId,
        calorie: calorie,
        day: day,
        isShown: isShown,
        date: date,
      );
      return ChangeCalorieGoalModel.fromJson(response);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}