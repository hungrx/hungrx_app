import 'package:hungrx_app/data/repositories/report_bug_repository.dart';

class ReportBugUseCase {
  final ReportBugRepository _repository;

  ReportBugUseCase(this._repository);

  Future<bool> execute(String userId, String report) async {
    if (report.isEmpty) {
      throw Exception('Bug report cannot be empty');
    }
    return await _repository.submitBugReport(userId, report);
  }
}