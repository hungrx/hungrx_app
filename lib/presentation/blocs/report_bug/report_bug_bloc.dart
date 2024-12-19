import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/report_bug_usecase.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_event.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_state.dart';

class ReportBugBloc extends Bloc<ReportBugEvent, ReportBugState> {
  final ReportBugUseCase _reportBugUseCase;

  ReportBugBloc(this._reportBugUseCase) : super(ReportBugInitial()) {
    on<ReportBugSubmitted>(_onReportBugSubmitted);
  }

  Future<void> _onReportBugSubmitted(
    ReportBugSubmitted event,
    Emitter<ReportBugState> emit,
  ) async {
    emit(ReportBugLoading());
    try {
      final success = await _reportBugUseCase.execute(
        event.userId,
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