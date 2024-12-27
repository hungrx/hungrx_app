import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';

class SearchState extends Equatable {
  final List<Dish> searchResults;
  final bool isLoading;
  final String error;

  const SearchState({
    this.searchResults = const [],
    this.isLoading = false,
    this.error = '',
  });

  SearchState copyWith({
    List<Dish>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [searchResults, isLoading, error];
}
