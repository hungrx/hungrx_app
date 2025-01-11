import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/get_search_history_log_response.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/get_search_history_log_usecase.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_event.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_state.dart';

class SearchHistoryLogBloc extends Bloc<SearchHistoryLogEvent, SearchHistoryLogState> {
  final GetSearchHistoryLogUseCase useCase;
  final AuthService _authService;

  SearchHistoryLogBloc({
    required this.useCase,
    required AuthService authService,
  })  : _authService = authService,
        super(SearchHistoryLogInitial()) {
    on<GetSearchHistoryLogRequested>(_onGetSearchHistoryLogRequested);
    on<SortSearchHistoryLogRequested>(_onSortSearchHistoryLogRequested);
  }

  Future<void> _onGetSearchHistoryLogRequested(
    GetSearchHistoryLogRequested event,
    Emitter<SearchHistoryLogState> emit,
  ) async {
    emit(SearchHistoryLogLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(SearchHistoryLogFailure(error: 'User not logged in'));
        return;
      }

      final items = await useCase.execute(userId);
      emit(SearchHistoryLogSuccess(
        items: items,
        currentSortOption: 'Recently Added',
      ));
    } catch (e) {
      emit(SearchHistoryLogFailure(error: e.toString()));
    }
  }

  Future<void> _onSortSearchHistoryLogRequested(
    SortSearchHistoryLogRequested event,
    Emitter<SearchHistoryLogState> emit,
  ) async {
    if (state is SearchHistoryLogSuccess) {
      final currentState = state as SearchHistoryLogSuccess;
      final sortedItems = List<GetSearchHistoryLogItem>.from(currentState.items);

      switch (event.sortOption) {
        case 'Recently Added':
          sortedItems.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
          break;
        case 'Alphabetical':
          sortedItems.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Calories: High to Low':
          sortedItems.sort((a, b) => (b.nutritionFacts.calories ?? 0)
              .compareTo(a.nutritionFacts.calories ?? 0));
          break;
        case 'Calories: Low to High':
          sortedItems.sort((a, b) => (a.nutritionFacts.calories ?? 0)
              .compareTo(b.nutritionFacts.calories ?? 0));
          break;
      }

      emit(currentState.copyWith(
        items: sortedItems,
        currentSortOption: event.sortOption,
      ));
    }
  }
}
