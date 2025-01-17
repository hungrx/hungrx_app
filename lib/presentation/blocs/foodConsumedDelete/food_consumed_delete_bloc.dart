import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/daily_insight_screen/delete_consumed_food_request.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/daily_insight_screen/delete_consumed_food_usecase.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_event.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_state.dart';

class DeleteFoodBloc extends Bloc<DeleteFoodEvent, DeleteFoodState> {
  final DeleteConsumedFoodUseCase _deleteConsumedFoodUseCase;
  final AuthService _authService;

  DeleteFoodBloc(
    this._deleteConsumedFoodUseCase,
    this._authService,
  ) : super(DeleteFoodInitial()) {
    on<DeleteConsumedFoodRequested>(_onDeleteConsumedFoodRequested);
  }

  Future<void> _onDeleteConsumedFoodRequested(
    DeleteConsumedFoodRequested event,
    Emitter<DeleteFoodState> emit,
  ) async {
    emit(DeleteFoodLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(DeleteFoodFailure('User not logged in'));
        return;
      }

      final request = DeleteFoodRequest(
        userId: userId,
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