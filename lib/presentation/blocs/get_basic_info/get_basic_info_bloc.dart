import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/get_basic_info_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_state.dart';

class GetBasicInfoBloc extends Bloc<GetBasicInfoEvent, GetBasicInfoState> {
  final GetBasicInfoUseCase _useCase;

  GetBasicInfoBloc(this._useCase) : super(GetBasicInfoInitial()) {
    on<GetBasicInfoRequested>(_onGetBasicInfoRequested);
  }

  Future<void> _onGetBasicInfoRequested(
    GetBasicInfoRequested event,
    Emitter<GetBasicInfoState> emit,
  ) async {
    emit(GetBasicInfoLoading());

    try {
      final response = await _useCase.execute(event.userId);
      emit(GetBasicInfoSuccess(response.data));
    } catch (e) {
      emit(GetBasicInfoFailure(e.toString()));
    }
  }
}