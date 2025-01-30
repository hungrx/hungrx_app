import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/get_basic_info_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_state.dart';

class GetBasicInfoBloc extends Bloc<GetBasicInfoEvent, GetBasicInfoState> {
  final GetBasicInfoUseCase _useCase;
  final AuthService _authService; // Add AuthService

  GetBasicInfoBloc(
    this._useCase,
    this._authService, // Inject AuthService
  ) : super(GetBasicInfoInitial()) {
    on<GetBasicInfoRequested>(_onGetBasicInfoRequested);
  }

  Future<void> _onGetBasicInfoRequested(
    GetBasicInfoRequested event,
    Emitter<GetBasicInfoState> emit,
  ) async {
    emit(GetBasicInfoLoading());

    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(GetBasicInfoFailure('User not logged in'));
        return;
      }

      final response = await _useCase.execute(userId);
      emit(GetBasicInfoSuccess(response.data));
    } catch (e) {
      emit(GetBasicInfoFailure(e.toString()));
    }
  }
}