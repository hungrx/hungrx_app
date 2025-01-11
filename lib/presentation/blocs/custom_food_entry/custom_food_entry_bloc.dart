import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/custom_food_entry_usecase.dart';
import 'package:hungrx_app/presentation/blocs/custom_food_entry/custom_food_entry_event.dart';
import 'package:hungrx_app/presentation/blocs/custom_food_entry/custom_food_entry_state.dart';

class CustomFoodEntryBloc extends Bloc<CustomFoodEntryEvent, CustomFoodEntryState> {
  final CustomFoodEntryUseCase _useCase;

  CustomFoodEntryBloc(this._useCase) : super(CustomFoodEntryInitial()) {
    on<CustomFoodEntrySubmitted>(_onCustomFoodEntrySubmitted);
  }

  Future<void> _onCustomFoodEntrySubmitted(
    CustomFoodEntrySubmitted event,
    Emitter<CustomFoodEntryState> emit,
  ) async {
    emit(CustomFoodEntryLoading());

    try {
      final response = await _useCase.execute(
        userId: event.userId,
        mealType: event.mealType,
        foodName: event.foodName,
        calories: event.calories,
      );
      emit(CustomFoodEntrySuccess(response));
    } catch (e) {
      print(e);
      emit(CustomFoodEntryFailure(e.toString()));
    }
  }
}