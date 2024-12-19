import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/search_restaurants_usecase.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_state.dart';

class RestaurantSearchBloc extends Bloc<RestaurantSearchEvent, RestaurantSearchState> {
  final SearchRestaurantsUseCase _searchUseCase;
  Timer? _debounceTimer;
  
  RestaurantSearchBloc({
    SearchRestaurantsUseCase? searchUseCase,
  })  : _searchUseCase = searchUseCase ?? SearchRestaurantsUseCase(),
        super(RestaurantSearchInitial()) {
    on<RestaurantSearchQueryChanged>(_onQueryChanged);
  }

void _onQueryChanged(
  RestaurantSearchQueryChanged event,
  Emitter<RestaurantSearchState> emit,
) async {
  // Clear previous timer
  _debounceTimer?.cancel();

  // If query is empty, return to initial state
  if (event.query.isEmpty) {
    emit(RestaurantSearchInitial());
    return;
  }

  // Show loading state immediately for better UX
  emit(RestaurantSearchLoading());

  // Use a Completer to handle the debounced API call
  final completer = Completer<void>();
  
  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    completer.complete();
  });

  // Wait for the debounce timer
  await completer.future;

  // Check if bloc is still active
  if (isClosed) return;

  try {
    final restaurants = await _searchUseCase.execute(event.query);

    // Check if bloc is still active
    if (isClosed) return;

    if (restaurants.isEmpty) {
      emit(RestaurantSearchEmpty());
    } else {
      emit(RestaurantSearchSuccess(restaurants));
    }
  } catch (e) {
    if (!isClosed) {
      emit(RestaurantSearchError(_formatErrorMessage(e.toString())));
    }
  }
}

  String _formatErrorMessage(String error) {
    // Clean up error message for better user experience
    if (error.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }
    if (error.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    // Add more error message formatting as needed
    return 'Failed to search restaurants. Please try again.';
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}