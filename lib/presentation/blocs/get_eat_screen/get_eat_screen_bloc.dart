import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/get_eat_screen_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_state.dart';

class EatScreenBloc extends Bloc<EatScreenEvent, EatScreenState> {
  final GetEatScreenUseCase _useCase;

  EatScreenBloc(this._useCase) : super(EatScreenInitial()) {
    on<GetEatScreenDataEvent>(_onGetEatScreenData);
  }

  Future<void> _onGetEatScreenData(
    GetEatScreenDataEvent event,
    Emitter<EatScreenState> emit,
  ) async {
    try {
      emit(EatScreenLoading());
      final result = await _useCase.execute(event.userId);
      emit(EatScreenLoaded(result));
    } catch (e) {
      emit(EatScreenError(e.toString()));
    }
  }
}