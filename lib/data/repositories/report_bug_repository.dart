import 'package:hungrx_app/data/datasources/api/report_bug_api.dart';

class ReportBugRepository {
  final ReportBugApi _api;

  ReportBugRepository(this._api);

  Future<bool> submitBugReport(String userId, String report) async {
    try {
      final response = await _api.reportBug(userId, report);
      return response['status'] == true;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}