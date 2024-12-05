import 'package:hungrx_app/data/Models/eat_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen_api_service.dart';

class EatScreenRepository {
  final EatScreenApiService _apiService;

  EatScreenRepository(this._apiService);

  Future<EatScreenModel> getEatScreenData(String userId) async {
    try {
      final json = await _apiService.getEatScreenData(userId);
      return EatScreenModel.fromJson(json);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}