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

  // Enhanced query preprocessing to handle calorie ranges
  SearchCriteria _preprocessSearchQuery(String query) {
    final terms = <String>[];
    CalorieRange? calorieRange;

    // Try to parse the entire query as a single calorie value first
    final singleCalorieValue = int.tryParse(query.trim());
    if (singleCalorieValue != null && singleCalorieValue > 0) {
      // Create a range for a single calorie value (e.g., 300 becomes 250-350)
      final range = (singleCalorieValue * 0.15).round(); // 15% range
      return SearchCriteria(
        searchTerms: [], // Empty terms since this is purely a calorie search
        calorieRange: CalorieRange(
          min: singleCalorieValue - range,
          max: singleCalorieValue + range,
        ),
      );
    }

    // Split the query into words for more complex queries
    final words = query.toLowerCase().split(' ');

    // Check if query contains only a number followed by "cal" or "calories"
    if (words.length == 2 &&
        int.tryParse(words[0]) != null &&
        (words[1].contains('cal') || words[1].contains('kcal'))) {
      final calories = int.tryParse(words[0]) ?? 0;
      if (calories > 0) {
        final range = (calories * 0.15).round(); // 15% range
        return SearchCriteria(
          searchTerms: [],
          calorieRange: CalorieRange(
            min: calories - range,
            max: calories + range,
          ),
        );
      }
    }

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      // Check for calorie range patterns
      if (word.contains('cal') || word.contains('kcal')) {
        calorieRange = _extractCalorieRange(words, i);
        continue;
      }

      // Check for numeric values that might be calories
      if (i < words.length - 1 && int.tryParse(word) != null) {
        final nextWord = words[i + 1];
        if (nextWord.contains('cal') || nextWord.contains('kcal')) {
          continue; // Skip this word as it will be handled in the next iteration
        }
      }

      // Add valid search terms
      if (word.length > 1) {
        terms.add(word);
      }
    }

    return SearchCriteria(
      searchTerms: terms,
      calorieRange: calorieRange,
    );
  }

  CalorieRange? _extractCalorieRange(List<String> words, int calorieWordIndex) {
    try {
      // Handle different calorie search patterns
      final beforeWord =
          calorieWordIndex > 0 ? words[calorieWordIndex - 1] : '';

      // Pattern: "under X calories" or "below X calories"
      if (beforeWord.contains('under') || beforeWord.contains('below')) {
        final calories = int.tryParse(words[calorieWordIndex - 2]) ?? 0;
        if (calories > 0) return CalorieRange(max: calories);
      }

      // Pattern: "over X calories" or "above X calories"
      if (beforeWord.contains('over') || beforeWord.contains('above')) {
        final calories = int.tryParse(words[calorieWordIndex - 2]) ?? 0;
        if (calories > 0) return CalorieRange(min: calories);
      }

      // Pattern: "X-Y calories" or "between X and Y calories"
      if (beforeWord.contains('-')) {
        final range = beforeWord.split('-');
        if (range.length == 2) {
          final min = int.tryParse(range[0]) ?? 0;
          final max = int.tryParse(range[1]) ?? 0;
          if (min > 0 && max > 0) return CalorieRange(min: min, max: max);
        }
      }

      // Pattern: "X calories"
      final calories = int.tryParse(beforeWord);
      if (calories != null && calories > 0) {
        // Create a flexible range around the specified calories (±15%)
        final range = (calories * 0.15).round();
        return CalorieRange(min: calories - range, max: calories + range);
      }
    } catch (e) {
      print('Error parsing calorie range: $e');
    }
    return null;
  }

  List<Dish> _searchDishesInCategories(
    String query,
    List<MenuCategory> categories,
  ) {
    final List<Dish> results = [];
    final searchCriteria = _preprocessSearchQuery(query);

    for (var category in categories) {
      // Search in main category dishes
      results.addAll(_searchInDishList(category.dishes, searchCriteria));

      // Search in subcategories
      for (var subCategory in category.subCategories) {
        results.addAll(_searchInDishList(subCategory.dishes, searchCriteria));
      }
    }

    // Sort results by relevance score
    results.sort((a, b) {
      final scoreA = _calculateRelevanceScore(a, searchCriteria);
      final scoreB = _calculateRelevanceScore(b, searchCriteria);
      return scoreB.compareTo(scoreA);
    });

    return results;
  }

  List<Dish> _searchInDishList(List<Dish> dishes, SearchCriteria criteria) {
    return dishes.where((dish) {
      // Check calorie range first if specified
      if (criteria.calorieRange != null) {
        final dishCalories = _getDishCalories(dish);
        if (!criteria.calorieRange!.isInRange(dishCalories)) {
          return false;
        }
      }

      // If only searching by calories and dish is in range, include it
      if (criteria.searchTerms.isEmpty && criteria.calorieRange != null) {
        return true;
      }

      // Check text-based relevance
      final score = _calculateRelevanceScore(dish, criteria);
      return score > 0;
    }).toList();
  }

  double _getDishCalories(Dish dish) {
    if (dish.servingInfos.isEmpty) return 0;
    // Get calories from the first serving size
    return double.tryParse(dish
            .servingInfos.first.servingInfo.nutritionFacts.calories.value) ??
        0;
  }

  double _calculateRelevanceScore(Dish dish, SearchCriteria criteria) {
    double score = 0.0;
    final dishName = dish.dishName.toLowerCase();
    final description = dish.description.toLowerCase();

    // Calculate text-based relevance
    for (var term in criteria.searchTerms) {
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
        if (_calculateLevenshteinDistance(word, term) <= 2) {
          score += 2.0;
        }
      }
    }

    // Add calorie range relevance if specified
    if (criteria.calorieRange != null) {
      final dishCalories = _getDishCalories(dish);
      score += _calculateCalorieRelevance(dishCalories, criteria.calorieRange!);
    }

    return score;
  }

  double _calculateCalorieRelevance(double dishCalories, CalorieRange range) {
    // Perfect match - dish calorie is very close to target
    if (range.isExactMatch(dishCalories)) {
      return 5.0;
    }

    // Within range but not exact
    if (range.isInRange(dishCalories)) {
      // Calculate how close to the ideal target the dish is
      double targetCalories = 0;

      if (range.min != null && range.max != null) {
        targetCalories = (range.min! + range.max!) / 2;
      } else if (range.min != null) {
        targetCalories = range.min! * 1.1; // 10% above minimum
      } else if (range.max != null) {
        targetCalories = range.max! * 0.9; // 10% below maximum
      }

      // Calculate closeness score (higher when closer to target)
      if (targetCalories > 0) {
        double deviation =
            (dishCalories - targetCalories).abs() / targetCalories;
        return 3.0 * (1.0 - min(deviation, 0.5) * 2); // Score between 1.0-3.0
      }

      return 2.0; // Default score for within range
    }

    return 0.0;
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

class SearchCriteria {
  final List<String> searchTerms;
  final CalorieRange? calorieRange;

  SearchCriteria({
    required this.searchTerms,
    this.calorieRange,
  });
}

class CalorieRange {
  final int? min;
  final int? max;

  CalorieRange({this.min, this.max});

  bool isInRange(double value) {
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }

  bool isExactMatch(double value) {
    if (min != null && max != null) {
      final target = (min! + max!) / 2;
      return (value - target).abs() <= 30; // Within 30 calories of target
    }
    return false;
  }
}
