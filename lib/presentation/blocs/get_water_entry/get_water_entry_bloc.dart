import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/water_screen/get_water_entry_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_event.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_state.dart';

class GetWaterIntakeBloc extends Bloc<GetWaterIntakeEvent, GetWaterIntakeState> {
  final GetWaterIntakeUseCase _getWaterIntakeUseCase;
  final AuthService _authService; // Add AuthService

  GetWaterIntakeBloc(
    this._getWaterIntakeUseCase,
    this._authService, // Inject AuthService
  ) : super(GetWaterIntakeInitial()) {
    on<FetchWaterIntakeData>(_onFetchWaterIntakeData);
  }

  Future<void> _onFetchWaterIntakeData(
    FetchWaterIntakeData event,
    Emitter<GetWaterIntakeState> emit,
  ) async {
    emit(GetWaterIntakeLoading());
    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(GetWaterIntakeError('User not logged in'));
        return;
      }

      final data = await _getWaterIntakeUseCase.execute(userId, event.date);
      emit(GetWaterIntakeLoaded(data));
    } catch (e) {
      emit(GetWaterIntakeError(e.toString()));
    }
  }
}