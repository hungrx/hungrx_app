import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/nearby_restaurant_repository.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_state.dart';

class NearbyRestaurantBloc extends Bloc<NearbyRestaurantEvent, NearbyRestaurantState> {
  final NearbyRestaurantRepository _repository;
  double _searchRadius = 5000; // Default radius

  NearbyRestaurantBloc(this._repository) : super(NearbyRestaurantInitial()) {
    on<FetchNearbyRestaurants>(_onFetchNearbyRestaurants);
    on<UpdateSearchRadius>(_onUpdateSearchRadius);
  }

  void _onUpdateSearchRadius(
    UpdateSearchRadius event,
    Emitter<NearbyRestaurantState> emit,
  ) {
    _searchRadius = event.radius;
    add(FetchNearbyRestaurants()); // Refresh restaurants with new radius
  }

  Future<void> _onFetchNearbyRestaurants(
    FetchNearbyRestaurants event,
    Emitter<NearbyRestaurantState> emit,
  ) async {
    emit(NearbyRestaurantLoading());
    try {
      final restaurants = await _repository.getNearbyRestaurants(radius: _searchRadius);
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