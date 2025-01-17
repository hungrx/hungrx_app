import 'package:hungrx_app/data/Models/dashboad_screen/calorie_metrics_dialog.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/calorie_metrics_repository.dart';

class GetCalorieMetricsUseCase {
  final CalorieMetricsRepository _repository;

  GetCalorieMetricsUseCase(this._repository);

  Future<CalorieMetricsModel> execute(String userId) async {
    return await _repository.getCalorieMetrics(userId);
  }
}