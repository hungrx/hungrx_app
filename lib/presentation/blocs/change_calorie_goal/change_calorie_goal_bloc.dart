import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/change_calorie_goal_usecase.dart';
import 'package:hungrx_app/presentation/blocs/change_calorie_goal/change_calorie_goal_event.dart';
import 'package:hungrx_app/presentation/blocs/change_calorie_goal/change_calorie_goal_state.dart';

class ChangeCalorieGoalBloc
    extends Bloc<ChangeCalorieGoalEvent, ChangeCalorieGoalState> {
  final ChangeCalorieGoalUseCase _useCase;
  final AuthService _authService;

  ChangeCalorieGoalBloc(
    this._useCase,
    this._authService,
  ) : super(ChangeCalorieGoalInitial()) {
    on<SubmitChangeCalorieGoal>(_onSubmitChangeCalorieGoal);
  }

  Future<void> _onSubmitChangeCalorieGoal(
    SubmitChangeCalorieGoal event,
    Emitter<ChangeCalorieGoalState> emit,
  ) async {
    emit(ChangeCalorieGoalLoading());

    try {
      final userId = await _authService.getUserId();

      if (userId == null) {
        emit(ChangeCalorieGoalFailure('User not logged in'));
        return;
      }

      final result = await _useCase.execute(
        userId: userId,
        calorie: event.calorie,
        day: event.day,
        isShown: event.isShown,
        date: event.date,
      );
      emit(ChangeCalorieGoalSuccess(result));
    } catch (e) {
      emit(ChangeCalorieGoalFailure(e.toString()));
    }
  }
}
