import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/add_common_food_history_request.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/add_common_food_history_usecase.dart';
import 'package:hungrx_app/presentation/blocs/add_common_food_history/add_common_food_history_event.dart';
import 'package:hungrx_app/presentation/blocs/add_common_food_history/add_common_food_history_state.dart';

class AddCommonFoodHistoryBloc extends Bloc<AddCommonFoodHistoryEvent, AddCommonFoodHistoryState> {
  final AddCommonFoodHistoryUseCase _useCase;

  AddCommonFoodHistoryBloc(this._useCase) : super(AddCommonFoodHistoryInitial()) {
    on<AddCommonFoodHistorySubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    AddCommonFoodHistorySubmitted event,
    Emitter<AddCommonFoodHistoryState> emit,
  ) async {
    emit(AddCommonFoodHistoryLoading());

    try {
      final request = AddCommonFoodHistoryRequest(
        userId: event.userId,
        dishId: event.dishId,
      );

      final response = await _useCase.execute(request);
      emit(AddCommonFoodHistorySuccess(response));
    } catch (e) {
      emit(AddCommonFoodHistoryFailure(e.toString()));
    }
  }
}