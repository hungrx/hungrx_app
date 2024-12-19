import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/get_meal_types_usecase.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_event.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_state.dart';

class MealTypeBloc extends Bloc<MealTypeEvent, MealTypeState> {
  final GetMealTypesUseCase getMealTypesUseCase;

  MealTypeBloc({required this.getMealTypesUseCase}) : super(MealTypeInitial()) {
    on<FetchMealTypes>(_onFetchMealTypes);
    on<SelectMealType>(_onSelectMealType);
  }

  Future<void> _onFetchMealTypes(
    FetchMealTypes event,
    Emitter<MealTypeState> emit,
  ) async {
    emit(MealTypeLoading());
    try {
      final mealTypes = await getMealTypesUseCase.execute();
      emit(MealTypeLoaded(mealTypes: mealTypes));
    } catch (e) {
      emit(MealTypeError(message: e.toString()));
    }
  }

  Future<void> _onSelectMealType(
    SelectMealType event,
    Emitter<MealTypeState> emit,
  ) async {
    final currentState = state;
    if (currentState is MealTypeLoaded) {
      emit(MealTypeLoaded(
        mealTypes: currentState.mealTypes,
        selectedMealId: event.mealId,
      ));
    }
  }
}