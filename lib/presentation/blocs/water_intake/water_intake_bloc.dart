import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/water_screen/water_intake_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'water_intake_event.dart';
import 'water_intake_state.dart';

class WaterIntakeBloc extends Bloc<WaterIntakeEvent, WaterIntakeState> {
  final WaterIntakeRepository repository;
  final AuthService _authService; // Add AuthService

  WaterIntakeBloc({
    required this.repository,
    required AuthService authService, // Inject AuthService
  }) : _authService = authService,
       super(WaterIntakeInitial()) {
    on<AddWaterIntake>(_onAddWaterIntake);
  }

  Future<void> _onAddWaterIntake(
    AddWaterIntake event,
    Emitter<WaterIntakeState> emit,
  ) async {
    emit(WaterIntakeLoading());
    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(const WaterIntakeFailure('User not logged in'));
        return;
      }

      final response = await repository.addWaterIntake(
        userId: userId,
        amount: event.amount,
      );
      emit(WaterIntakeSuccess(response.data));
    } catch (e) {
      emit(WaterIntakeFailure(e.toString()));
    }
  }
}