import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/get_suggested_restaurants_usecase.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_event.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_state.dart';

class SuggestedRestaurantsBloc extends Bloc<SuggestedRestaurantsEvent, SuggestedRestaurantsState> {
  final GetSuggestedRestaurantsUseCase _useCase;

  SuggestedRestaurantsBloc(this._useCase) : super(SuggestedRestaurantsInitial()) {
    on<FetchSuggestedRestaurants>(_onFetchSuggestedRestaurants);
  }

  Future<void> _onFetchSuggestedRestaurants(
    FetchSuggestedRestaurants event,
    Emitter<SuggestedRestaurantsState> emit,
  ) async {
    emit(SuggestedRestaurantsLoading());
    try {
      final restaurants = await _useCase.execute();
      emit(SuggestedRestaurantsLoaded(restaurants));
    } catch (e) {
      emit(SuggestedRestaurantsError(e.toString()));
    }
  }
}