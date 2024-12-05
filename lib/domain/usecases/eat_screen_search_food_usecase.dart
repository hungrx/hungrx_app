import 'package:hungrx_app/data/Models/eat_screen_search_models.dart';
import 'package:hungrx_app/data/repositories/eat_search_screen_repository.dart';

class EatScreenSearchFoodUsecase {
  final EatSearchScreenRepository _repository;

  EatScreenSearchFoodUsecase(this._repository);

  Future<SearchResponseModel> execute(String query) async {
    if (query.isEmpty) {
      throw Exception('Search query cannot be empty');
    }
    return await _repository.searchFood(query);
  }
}