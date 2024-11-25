import 'package:hungrx_app/data/Models/weight_history_model.dart';
import 'package:hungrx_app/data/datasources/api/weight_history_api.dart';

class WeightHistoryRepository {
  final WeightHistoryApi _api;

  WeightHistoryRepository(this._api);

  Future<WeightHistoryModel> getWeightHistory(String userId) async {
    try {
      return await _api.getWeightHistory(userId);
    } catch (e) {
      throw Exception('Failed to fetch weight history: $e');
    }
  }
}