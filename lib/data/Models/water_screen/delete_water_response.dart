class DeleteWaterResponse {
  final bool success;
  final String message;
  final DeleteWaterData data;

  DeleteWaterResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeleteWaterResponse.fromJson(Map<String, dynamic> json) {
    return DeleteWaterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DeleteWaterData.fromJson(json['data'] ?? {}),
    );
  }
}

class DeleteWaterData {
  final String date;
  final int remainingEntries;
  final int updatedTotalIntake;
  final int updatedRemaining;

  DeleteWaterData({
    required this.date,
    required this.remainingEntries,
    required this.updatedTotalIntake,
    required this.updatedRemaining,
  });

  factory DeleteWaterData.fromJson(Map<String, dynamic> json) {
    return DeleteWaterData(
      date: json['date'] ?? '',
      remainingEntries: json['remainingEntries'] ?? 0,
      updatedTotalIntake: json['updatedTotalIntake'] ?? 0,
      updatedRemaining: json['updatedRemaining'] ?? 0,
    );
  }
}
