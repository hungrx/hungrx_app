import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/common_food_repository.dart';
import 'package:hungrx_app/presentation/blocs/common_food_search/common_food_search_event.dart';
import 'package:hungrx_app/presentation/blocs/common_food_search/common_food_search_state.dart';

class CommonFoodSearchBloc extends Bloc<CommonFoodSearchEvent, CommonFoodSearchState> {
  final CommonFoodRepository repository;

  CommonFoodSearchBloc({required this.repository}) : super(CommonFoodSearchInitial()) {
    on<CommonFoodSearchStarted>(_onSearchStarted);
    on<CommonFoodSearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchStarted(
    CommonFoodSearchStarted event,
    Emitter<CommonFoodSearchState> emit,
  ) async {
    emit(CommonFoodSearchLoading());
    try {
      final foods = await repository.searchCommonFood(event.query);
      emit(CommonFoodSearchSuccess(foods));
    } catch (e) {
      emit(CommonFoodSearchError(e.toString()));
    }
  }

  void _onSearchCleared(
    CommonFoodSearchCleared event,
    Emitter<CommonFoodSearchState> emit,
  ) {
    emit(CommonFoodSearchInitial());
  }
}