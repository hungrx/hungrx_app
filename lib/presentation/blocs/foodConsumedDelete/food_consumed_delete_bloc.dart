import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/delete_consumed_food_request.dart';
import 'package:hungrx_app/domain/usecases/delete_consumed_food_usecase.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_event.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_state.dart';

class DeleteFoodBloc extends Bloc<DeleteFoodEvent, DeleteFoodState> {
  final DeleteConsumedFoodUseCase _deleteConsumedFoodUseCase;

  DeleteFoodBloc(this._deleteConsumedFoodUseCase) : super(DeleteFoodInitial()) {
    on<DeleteConsumedFoodRequested>(_onDeleteConsumedFoodRequested);
  }

  Future<void> _onDeleteConsumedFoodRequested(
    DeleteConsumedFoodRequested event,
    Emitter<DeleteFoodState> emit,
  ) async {
    emit(DeleteFoodLoading());
    try {
      final request = DeleteFoodRequest(
        userId: event.userId,
        date: event.date,
        mealId: event.mealId,
        dishId: event.dishId,
      );
      final response = await _deleteConsumedFoodUseCase.execute(request);
      emit(DeleteFoodSuccess(response));
    } catch (e) {
      emit(DeleteFoodFailure(e.toString()));
    }
  }
}