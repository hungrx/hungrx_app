abstract class ReportBugEvent {}

class ReportBugSubmitted extends ReportBugEvent {
  final String report;

  ReportBugSubmitted({required this.report});
}