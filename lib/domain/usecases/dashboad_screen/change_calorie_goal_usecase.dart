import 'package:hungrx_app/data/Models/dashboad_screen/change_calorie_goal_model.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/change_calorie_goal_repository.dart';

class ChangeCalorieGoalUseCase {
  final ChangeCalorieGoalRepository _repository;

  ChangeCalorieGoalUseCase(this._repository);

  Future<ChangeCalorieGoalModel> execute({
    required String userId,
    required double calorie,
    required int day,  // Added day parameter
  }) async {
    return await _repository.changeCalorieGoal(
      userId: userId,
      calorie: calorie,
      day: day,  // Added day parameter
    );
  }
}