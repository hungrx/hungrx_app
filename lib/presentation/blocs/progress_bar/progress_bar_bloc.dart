import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/repositories/progress_bar/progress_bar_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_event.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';

class ProgressBarBloc extends Bloc<ProgressBarEvent, ProgressBarState> {
  final ProgressBarRepository repository;
  final AuthService _authService; // Add AuthService

  ProgressBarBloc(
    this.repository,
    this._authService, // Inject AuthService
  ) : super(ProgressBarInitial()) {
    on<FetchProgressBarData>(_onFetchProgressBarData);
  }

  Future<void> _onFetchProgressBarData(
    FetchProgressBarData event,
    Emitter<ProgressBarState> emit,
  ) async {
    emit(ProgressBarLoading());
    try {
      // Get userId from AuthService
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(ProgressBarError('User not logged in'));
        return;
      }

      final data = await repository.getProgressBarData(userId);
      emit(ProgressBarLoaded(data));
    } catch (e) {
      emit(ProgressBarError(e.toString()));
    }
  }
}

