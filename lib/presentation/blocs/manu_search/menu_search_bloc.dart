import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchDishes>(_onSearchDishes);
    on<ClearSearch>(_onClearSearch);
  }

  void _onSearchDishes(SearchDishes event, Emitter<SearchState> emit) {
    emit(state.copyWith(isLoading: true));
    
    try {
      if (event.query.trim().isEmpty) {
        emit(state.copyWith(
          searchResults: const [],
          isLoading: false,
          error: '',
        ));
        return;
      }

      final results = _searchDishesInCategories(
        event.query.trim(),
        event.categories,
      );
      
      emit(state.copyWith(
        searchResults: results,
        isLoading: false,
        error: results.isEmpty ? 'No dishes found' : '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error searching dishes: $e',
      ));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }

  List<Dish> _searchDishesInCategories(
    String query,
    List<MenuCategory> categories,
  ) {
    final List<Dish> results = [];
    final List<String> searchTerms = _preprocessSearchQuery(query);
    
    for (var category in categories) {
      // Search in main category dishes with relevance scoring
      results.addAll(_searchInDishList(category.dishes, searchTerms));
      
      // Search in subcategories with relevance scoring
      for (var subCategory in category.subCategories) {
        results.addAll(_searchInDishList(subCategory.dishes, searchTerms));
      }
    }
    
    // Sort results by relevance score
    results.sort((a, b) {
      final scoreA = _calculateRelevanceScore(a, searchTerms);
      final scoreB = _calculateRelevanceScore(b, searchTerms);
      return scoreB.compareTo(scoreA); // Higher score first
    });
    
    return results;
  }

  List<String> _preprocessSearchQuery(String query) {
    // Split query into individual terms and remove common words
    return query
        .toLowerCase()
        .split(' ')
        .where((term) => term.length > 1) // Filter out very short terms
        .toList();
  }

  List<Dish> _searchInDishList(List<Dish> dishes, List<String> searchTerms) {
    return dishes.where((dish) {
      final score = _calculateRelevanceScore(dish, searchTerms);
      return score > 0; // Only include dishes with positive relevance score
    }).toList();
  }

  double _calculateRelevanceScore(Dish dish, List<String> searchTerms) {
    double score = 0.0;
    final dishName = dish.dishName.toLowerCase();
    final description = dish.description.toLowerCase();

    for (var term in searchTerms) {
      // Exact match in name (highest weight)
      if (dishName == term) {
        score += 10.0;
      }
      // Word match in name
      else if (dishName.split(' ').contains(term)) {
        score += 5.0;
      }
      // Partial match in name
      else if (dishName.contains(term)) {
        score += 3.0;
      }
      
      // Word match in description
      if (description.split(' ').contains(term)) {
        score += 2.0;
      }
      // Partial match in description
      else if (description.contains(term)) {
        score += 1.0;
      }

      // Levenshtein distance for fuzzy matching
      final nameWords = dishName.split(' ');
      for (var word in nameWords) {
        if (_calculateLevenshteinDistance(word, term) <= 2) { // Allow 2 character differences
          score += 2.0;
        }
      }
    }

    return score;
  }

  int _calculateLevenshteinDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    List<int> previousRow = List<int>.generate(b.length + 1, (i) => i);
    List<int> currentRow = List<int>.filled(b.length + 1, 0);

    for (int i = 0; i < a.length; i++) {
      currentRow[0] = i + 1;

      for (int j = 0; j < b.length; j++) {
        int insertCost = previousRow[j + 1] + 1;
        int deleteCost = currentRow[j] + 1;
        int replaceCost = previousRow[j] + (a[i] != b[j] ? 1 : 0);

        currentRow[j + 1] = [insertCost, deleteCost, replaceCost].reduce(min);
      }

      List<int> temp = previousRow;
      previousRow = currentRow;
      currentRow = temp;
    }

    return previousRow[b.length];
  }
}