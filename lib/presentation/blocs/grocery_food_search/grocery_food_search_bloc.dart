import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/food_search_repository.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_event.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FoodSearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    // Register the event handlers
    on<SearchQueryChanged>(_onSearchQueryChanged);  // Keep this for backward compatibility
    on<PerformSearch>(_onPerformSearch);  // Add this line
    on<ClearSearch>((event, emit) {
      emit(SearchInitial());
    });
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final foods = await repository.searchFood(event.query);
      emit(SearchSuccess(foods));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  // Keep this method for backward compatibility
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    // Simply forward to _onPerformSearch
    await _onPerformSearch(PerformSearch(event.query), emit);
  }
}
