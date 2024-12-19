import 'package:hungrx_app/data/Models/eat_screen/eat_screen_search_models.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen/eat_search_screen_api_service.dart';

class EatSearchScreenRepository {
  final EatSearchScreenApiService _apiService;

  EatSearchScreenRepository(this._apiService);

  Future<SearchResponseModel> searchFood(String query) async {
    try {
      final response = await _apiService.searchFood(query);
      return SearchResponseModel.fromJson(response);
    } catch (e) {
      // print(e);
      throw Exception('Repository error: $e');
    }
  }
}