abstract class ReportBugEvent {}

class ReportBugSubmitted extends ReportBugEvent {
  final String userId;
  final String report;

  ReportBugSubmitted({required this.userId, required this.report});
}