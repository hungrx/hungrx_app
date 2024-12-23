import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/nearby_restaurant_repository.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_state.dart';

class NearbyRestaurantBloc extends Bloc<NearbyRestaurantEvent, NearbyRestaurantState> {
  final NearbyRestaurantRepository _repository;

  NearbyRestaurantBloc(this._repository) : super(NearbyRestaurantInitial()) {
    on<FetchNearbyRestaurants>(_onFetchNearbyRestaurants);
  }

  Future<void> _onFetchNearbyRestaurants(
    FetchNearbyRestaurants event,
    Emitter<NearbyRestaurantState> emit,
  ) async {
    emit(NearbyRestaurantLoading());
    try {
      final restaurants = await _repository.getNearbyRestaurants();
      if (restaurants.isEmpty) {
        emit(NearbyRestaurantError('No nearby restaurants found'));
      } else {
        emit(NearbyRestaurantLoaded(restaurants));
      }
    } catch (e) {
      emit(NearbyRestaurantError(e.toString()));
    }
  }
}