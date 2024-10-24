import 'package:hungrx_app/core/utils/api_exception.dart';
import 'package:hungrx_app/data/Models/tdee_result_model.dart';
import 'package:hungrx_app/data/datasources/api/tdee_api_service.dart';

class TDEERepository {
  final TDEEApiService _apiService;

  TDEERepository(this._apiService);

  Future<TDEEResultModel> calculateMetrics(String userId) async {
    try {
      final data = await _apiService.calculateMetrics(userId);
      return TDEEResultModel.fromJson(data);
    } on ApiException catch (e) {
      throw ApiException(message: 'Repository Error: ${e.message}');
    } catch (e) {
      throw ApiException(message: 'Unexpected Repository Error: $e');
    }
  }

  void dispose() {
    _apiService.dispose();
  }
}
