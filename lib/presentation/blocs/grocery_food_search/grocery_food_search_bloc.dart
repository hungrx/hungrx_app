import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/food_search_repository.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_event.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FoodSearchRepository repository;
  Timer? _debounceTimer;

  SearchBloc(this.repository) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>((event, emit) {
    emit( SearchInitial()); // Reset to initial state
  });
  }

  FutureOr<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Create a completer to handle the debounced operation
    final completer = Completer<void>();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        emit(SearchLoading());
        
        // Await the repository call
        final foods = await repository.searchFood(event.query);
        
        if (!emit.isDone) {
          emit(SearchSuccess(foods));
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(SearchError(e.toString()));
        }
      } finally {
        completer.complete();
      }
    });

    // Wait for the debounced operation to complete
    await completer.future;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}