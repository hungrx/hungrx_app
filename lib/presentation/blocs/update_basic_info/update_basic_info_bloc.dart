import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/update_basic_info_usecase.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_state.dart';

class UpdateBasicInfoBloc extends Bloc<UpdateBasicInfoEvent, UpdateBasicInfoState> {
  final UpdateBasicInfoUseCase _useCase;

  UpdateBasicInfoBloc(this._useCase) : super(UpdateBasicInfoInitial()) {
    on<UpdateBasicInfoSubmitted>(_onUpdateBasicInfoSubmitted);
  }

  Future<void> _onUpdateBasicInfoSubmitted(
    UpdateBasicInfoSubmitted event,
    Emitter<UpdateBasicInfoState> emit,
  ) async {
    emit(UpdateBasicInfoLoading());
    try {
      final response = await _useCase.execute(event.request);
      emit(UpdateBasicInfoSuccess(response));
    } catch (e) {
      emit(UpdateBasicInfoFailure(e.toString()));
    }
  }
}