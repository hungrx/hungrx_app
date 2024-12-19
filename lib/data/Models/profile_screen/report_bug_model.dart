class ReportBugModel {
  final String userId;
  final String report;
  
  ReportBugModel({required this.userId, required this.report});
  
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'report': report,
  };
  
  factory ReportBugModel.fromJson(Map<String, dynamic> json) => ReportBugModel(
    userId: json['userId'],
    report: json['report'],
  );
}