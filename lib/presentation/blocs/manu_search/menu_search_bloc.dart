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
      final results = _searchDishesInCategories(
        event.query.toLowerCase(),
        event.categories,
      );
      
      emit(state.copyWith(
        searchResults: results,
        isLoading: false,
        error: '',
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
    List<Dish> results = [];
    
    for (var category in categories) {
      // Search in main category dishes
      results.addAll(category.dishes.where((dish) =>
          dish.dishName.toLowerCase().contains(query) ||
          dish.description.toLowerCase().contains(query)));
      
      // Search in subcategories
      for (var subCategory in category.subCategories) {
        results.addAll(subCategory.dishes.where((dish) =>
            dish.dishName.toLowerCase().contains(query) ||
            dish.description.toLowerCase().contains(query)));
      }
    }
    
    return results;
  }
}