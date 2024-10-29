class WeightUpdateResponse {
  final bool success;
  final String message;

  WeightUpdateResponse({required this.success, required this.message});

  factory WeightUpdateResponse.fromJson(Map<String, dynamic> json) {
    return WeightUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown response',
    );
  }
}