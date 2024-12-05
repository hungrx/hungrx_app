import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/eat_screen_search_food_usecase.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_event.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_state.dart';
import 'package:rxdart/rxdart.dart';

class EatScreenSearchBloc extends Bloc<EatScreenSearchEvent, EatScreenSearchState> {
  final EatScreenSearchFoodUsecase searchUseCase;
  Timer? _debounceTimer;

  EatScreenSearchBloc({required this.searchUseCase}) : super(SearchInitial()) {
    on<SearchTextChanged>(
      _onSearchTextChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onSearchTextChanged(
    SearchTextChanged event,
    Emitter<EatScreenSearchState> emit,
  ) async {
    final searchTerm = event.query.trim();

    if (searchTerm.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(searchTerm));

    try {
      final results = await searchUseCase.execute(searchTerm);
      if (results.data.isEmpty) {
        emit(SearchSuccess([], searchTerm));
      } else {
        emit(SearchSuccess(results.data, searchTerm));
      }
    } catch (error) {
      emit(SearchError(error.toString(), searchTerm));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
