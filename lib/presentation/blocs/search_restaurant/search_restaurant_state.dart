// restaurant_search_state.dart
import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';

class RestaurantSearchState extends Equatable {
  final List<SuggestedRestaurantModel> searchResults;
  final bool isLoading;
  final String error;

  const RestaurantSearchState({
    this.searchResults = const [],
    this.isLoading = false,
    this.error = '',
  });

   factory RestaurantSearchState.initial(List<SuggestedRestaurantModel> restaurants) {
    return RestaurantSearchState(searchResults: restaurants);
  }

  RestaurantSearchState copyWith({
    List<SuggestedRestaurantModel>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return RestaurantSearchState(
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [searchResults, isLoading, error];
}