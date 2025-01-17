import 'package:hungrx_app/data/Models/progress_bar/progress_bar_model.dart';
import 'package:hungrx_app/data/datasources/api/progress_bar/progress_bar_api.dart';

class ProgressBarRepository {
  final ProgressBarApi _api;

  ProgressBarRepository(this._api);

  Future<ProgressBarModel> getProgressBarData(String userId) async {
    try {
      final data = await _api.fetchProgressBarData(userId);
      return ProgressBarModel.fromJson(data);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}