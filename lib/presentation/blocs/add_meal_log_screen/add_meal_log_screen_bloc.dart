import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/add_meal_usecase.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_state.dart';

class AddMealBloc extends Bloc<AddMealEvent, AddMealState> {
  final AddMealUseCase _useCase;

  AddMealBloc({AddMealUseCase? useCase})
      : _useCase = useCase ?? AddMealUseCase(),
        super(AddMealInitial()) {
    on<AddMealSubmitted>(_onAddMealSubmitted);
  }

  Future<void> _onAddMealSubmitted(
    AddMealSubmitted event,
    Emitter<AddMealState> emit,
  ) async {
    emit(AddMealLoading());

    try {
      final response = await _useCase.execute(event.request);
      emit(AddMealSuccess(response));
    } catch (e) {
      emit(AddMealFailure(e.toString()));
    }
  }
}
