import 'package:bloc/bloc.dart';
import 'package:hungrx_app/domain/usecases/timezone/update_timezone_usecase.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_event.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_state.dart';

class TimezoneBloc extends Bloc<TimezoneEvent, TimezoneState> {
  final UpdateTimezoneUseCase _updateTimezoneUseCase;

  TimezoneBloc(this._updateTimezoneUseCase) : super(TimezoneInitial()) {
    on<UpdateUserTimezone>(_onUpdateUserTimezone);
  }

  Future<void> _onUpdateUserTimezone(
    UpdateUserTimezone event,
    Emitter<TimezoneState> emit,
  ) async {
    emit(TimezoneUpdating());
    try {
      final timezone = await _updateTimezoneUseCase.execute(event.userId);
      emit(TimezoneUpdateSuccess(timezone));
    } catch (e) {
      emit(TimezoneUpdateFailure(e.toString()));
    }
  }
}