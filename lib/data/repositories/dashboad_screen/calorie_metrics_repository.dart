import 'package:hungrx_app/data/Models/dashboad_screen/calorie_metrics_dialog.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/calorie_metrics_api.dart';

class CalorieMetricsRepository {
  final CalorieMetricsApi _api;

  CalorieMetricsRepository(this._api);

  Future<CalorieMetricsModel> getCalorieMetrics(String userId) async {
    try {
      final Map<String, dynamic> response = await _api.getCalorieMetrics(userId);
      return CalorieMetricsModel.fromJson(response);
    } catch (e) {
      print("new error $e");
      throw Exception('Repository error: $e');
    }
  }
}