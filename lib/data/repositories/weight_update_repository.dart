import 'package:hungrx_app/data/Models/weight_response_model.dart';
import 'package:hungrx_app/data/Models/weight_update_model.dart';
import 'package:hungrx_app/data/datasources/api/weight_update_api.dart';

class WeightUpdateRepository {
  final WeightUpdateApiService _apiService;

  WeightUpdateRepository(this._apiService);

  Future<WeightUpdateResponse> updateWeight(String userId, double newWeight) async {
    try {
      final weightUpdate = WeightUpdateModel(
        userId: userId,
        newWeight: newWeight,
      );
      return await _apiService.updateWeight(weightUpdate);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}