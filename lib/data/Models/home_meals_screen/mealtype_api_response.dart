class MealtypeApiResponse<T> {
  final bool status;
  final String message;
  final T data;

  MealtypeApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MealtypeApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return MealtypeApiResponse(
      status: json['status'],
      message: json['message'],
      data: fromJson(json['data']),
    );
  }
}