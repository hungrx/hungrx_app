abstract class ReportBugState {}

class ReportBugInitial extends ReportBugState {}

class ReportBugLoading extends ReportBugState {}

class ReportBugSuccess extends ReportBugState {
  final String message;
  ReportBugSuccess(this.message);
}

class ReportBugFailure extends ReportBugState {
  final String error;
  ReportBugFailure(this.error);
}