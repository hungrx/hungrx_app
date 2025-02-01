// restaurant_search_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_state.dart';

class RestaurantSearchBloc extends Bloc<RestaurantSearchEvent, RestaurantSearchState> {
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

      // Split query into words for better matching
      final queryWords = query.split(' ').where((word) => word.isNotEmpty).toList();
      
      final results = allRestaurants.where((restaurant) {
        final name = restaurant.name.toLowerCase();
        final address = restaurant.address?.toLowerCase() ?? '';
        
        // Check each word in the query
        bool matchesQuery = queryWords.any((word) {
          // Check for partial matches in name
          if (name.contains(word)) return true;
          
          // Check for word starts with
          if (_findWordsStartingWith(name, word).isNotEmpty) return true;
          
          // Check for partial matches in address
          if (address.contains(word)) return true;
          
          // Check for matches with removed spaces
          final nameNoSpaces = name.replaceAll(' ', '');
          if (nameNoSpaces.contains(word)) return true;

          // Check for approximate matches (allowing one character difference)
          if (_hasApproximateMatch(name, word)) return true;
          
          return false;
        });

        return matchesQuery;
      }).toList();

      // Sort results by relevance
      results.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        
        // Exact matches come first
        if (aName.contains(query) && !bName.contains(query)) return -1;
        if (bName.contains(query) && !aName.contains(query)) return 1;
        
        // Then starts-with matches
        if (aName.startsWith(query) && !bName.startsWith(query)) return -1;
        if (bName.startsWith(query) && !aName.startsWith(query)) return 1;
        
        // Finally, sort by name length (shorter names first)
        return aName.length.compareTo(bName.length);
      });

      debugPrint('Search query: $query');
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

  void _onClearSearch(ClearRestaurantSearch event, Emitter<RestaurantSearchState> emit) {
    emit(RestaurantSearchState.initial(allRestaurants));
  }

  // Helper function to find words starting with the query
  List<String> _findWordsStartingWith(String text, String prefix) {
    return text
        .split(' ')
        .where((word) => word.trim().startsWith(prefix))
        .toList();
  }

  // Helper function to check for approximate matches (allowing one character difference)
  bool _hasApproximateMatch(String text, String query) {
    if (query.length < 3) return false; // Only check for queries of 3 or more characters
    
    final words = text.split(' ');
    for (final word in words) {
      if (word.length < query.length - 1) continue;
      
      // Check for one character difference
      var differences = 0;
      for (var i = 0; i < query.length && i < word.length; i++) {
        if (query[i] != word[i]) differences++;
        if (differences > 1) break;
      }
      if (differences <= 1) return true;
    }
    return false;
  }
}