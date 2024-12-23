import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/suggested_restaurants_repository.dart';

class GetSuggestedRestaurantsUseCase {
  final SuggestedRestaurantsRepository _repository;

  GetSuggestedRestaurantsUseCase(this._repository);

  Future<List<SuggestedRestaurantModel>> execute() async {
    return await _repository.getSuggestedRestaurants();
  }
}