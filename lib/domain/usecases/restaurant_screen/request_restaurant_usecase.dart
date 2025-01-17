import 'package:hungrx_app/data/Models/restuarent_screen/request_restaurant_model.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/request_restaurant_repository.dart';

class RequestRestaurantUseCase {
  final RequestRestaurantRepository repository;

  RequestRestaurantUseCase(this.repository);

  Future<bool> execute(RequestRestaurantModel request) {
    return repository.requestRestaurant(request);
  }
}