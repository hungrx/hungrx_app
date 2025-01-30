import 'package:bloc/bloc.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/common_consume_food_usecase.dart';
import 'package:hungrx_app/presentation/blocs/consume_common_food/consume_common_food_event.dart';
import 'package:hungrx_app/presentation/blocs/consume_common_food/consume_common_food_state.dart';
class CommonFoodBloc extends Bloc<CommonFoodEvent, CommonFoodState> {
  final CommonFoodUseCase _useCase;

  CommonFoodBloc(this._useCase) : super(CommonFoodInitial()) {
    on<CommonFoodSubmitted>(_onCommonFoodSubmitted);
  }

  Future<void> _onCommonFoodSubmitted(
    CommonFoodSubmitted event,
    Emitter<CommonFoodState> emit,
  ) async {
    emit(CommonFoodLoading());
    try {
      final response = await _useCase.execute(event.request);
      emit(CommonFoodSuccess(response));
    } catch (e) {
      emit(CommonFoodFailure(e.toString()));
    }
  }
}