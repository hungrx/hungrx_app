import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/update_weight_usecase.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_state.dart';

class WeightUpdateBloc extends Bloc<WeightUpdateEvent, WeightUpdateState> {
  final UpdateWeightUseCase _updateWeightUseCase;
  final AuthService _authService;

  WeightUpdateBloc(this._updateWeightUseCase, this._authService)
      : super(WeightUpdateInitial()) {
    on<UpdateWeightRequested>(_onUpdateWeightRequested);
  }

  Future<void> _onUpdateWeightRequested(
    UpdateWeightRequested event,
    Emitter<WeightUpdateState> emit,
  ) async {
    if (event.newWeight <= 0 || event.newWeight > 200) {
      emit(WeightUpdateError('Please enter a valid weight between 0 and 200 kg'));
      return;
    }
    emit(WeightUpdateLoading());

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(WeightUpdateError('User not authenticated'));
        return;
      }

      final response = await _updateWeightUseCase.execute(userId, event.newWeight);
      emit(WeightUpdateSuccess(response.message));
    } catch (e) {
      emit(WeightUpdateError(
        'Failed to update weight. Please check your internet connection and try again.',
      ));
    }
  }
}