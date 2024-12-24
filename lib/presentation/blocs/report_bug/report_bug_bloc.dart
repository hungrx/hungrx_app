import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/report_bug_usecase.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_event.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_state.dart';

class ReportBugBloc extends Bloc<ReportBugEvent, ReportBugState> {
  final ReportBugUseCase _reportBugUseCase;
  final AuthService _authService;

  ReportBugBloc(
    this._reportBugUseCase,
    this._authService,
  ) : super(ReportBugInitial()) {
    on<ReportBugSubmitted>(_onReportBugSubmitted);
  }

  Future<void> _onReportBugSubmitted(
    ReportBugSubmitted event,
    Emitter<ReportBugState> emit,
  ) async {
    emit(ReportBugLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(ReportBugFailure('User not logged in'));
        return;
      }

      final success = await _reportBugUseCase.execute(
        userId,
        event.report,
      );
      if (success) {
        emit(ReportBugSuccess('Bug report submitted successfully'));
      } else {
        emit(ReportBugFailure('Failed to submit bug report'));
      }
    } catch (e) {
      emit(ReportBugFailure(e.toString()));
    }
  }
}