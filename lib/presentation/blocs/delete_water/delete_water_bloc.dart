import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/water_screen/delete_water_entry_usecase.dart';
import 'package:hungrx_app/presentation/blocs/delete_water/delete_water_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_water/delete_water_state.dart';

class DeleteWaterBloc extends Bloc<DeleteWaterEvent, DeleteWaterState> {
  final DeleteWaterEntryUseCase _deleteWaterEntryUseCase;
  final AuthService _authService; // Add AuthService

  DeleteWaterBloc(
    this._deleteWaterEntryUseCase,
    this._authService, // Inject AuthService
  ) : super(DeleteWaterIntakeInitial()) {
    on<DeleteWaterIntakeEntry>(_handleDeleteWaterEntry);
  }

  Future<void> _handleDeleteWaterEntry(
    DeleteWaterIntakeEntry event,
    Emitter<DeleteWaterState> emit,
  ) async {
    try {
      emit(DeleteWaterIntakeLoading());
      
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(DeleteWaterIntakeError(message: 'User not logged in'));
        return;
      }

      final response = await _deleteWaterEntryUseCase.execute(
        userId: userId, // Use userId from AuthService
        date: event.date,
        entryId: event.entryId,
      );

      if (response.success) {
        emit(DeleteWaterIntakeSuccess(
          message: response.message,
          data: response.data,
        ));
      } else {
        emit(DeleteWaterIntakeError(message: response.message));
      }
    } catch (e) {
      emit(DeleteWaterIntakeError(message: 'Failed to delete water entry: $e'));
    }
  }
}