// restaurant_search_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_state.dart';

class RestaurantSearchBloc
    extends Bloc<RestaurantSearchEvent, RestaurantSearchState> {
  final List<SuggestedRestaurantModel> allRestaurants;

  RestaurantSearchBloc(this.allRestaurants)
      : super(RestaurantSearchState.initial(allRestaurants)) {
    on<SearchRestaurants>(_onSearchRestaurants);
    on<ClearRestaurantSearch>(_onClearSearch);
  }

void _onSearchRestaurants(SearchRestaurants event, Emitter<RestaurantSearchState> emit) {
  emit(state.copyWith(isLoading: true));

  try {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(
        searchResults: allRestaurants,
        isLoading: false,
        error: '',
      ));
      return;
    }

    final results = allRestaurants.where((restaurant) {
      final name = restaurant.name.toLowerCase();
      final address = restaurant.address?.toLowerCase() ?? '';
      return name.contains(query) || address.contains(query);
    }).toList();
debugPrint('Search query: ${event.query}');
debugPrint('Results: ${results.length}');

    emit(state.copyWith(
      searchResults: results,
      isLoading: false,
      error: '',
    ));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: 'Error searching restaurants: $e',
    ));
  }
}


  void _onClearSearch(
      ClearRestaurantSearch event, Emitter<RestaurantSearchState> emit) {
    emit(RestaurantSearchState.initial(allRestaurants));
  }
}
