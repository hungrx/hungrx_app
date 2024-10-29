import 'package:hungrx_app/data/Models/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/home_screen_api_service.dart';

class HomeRepository {
  final HomeApiService _apiService;

  HomeRepository(this._apiService);

  Future<HomeData> getHomeData(String userId) async {
    try {
      return await _apiService.fetchHomeData(userId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}