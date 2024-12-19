  class DeleteAccountResponse {
    final bool status;
    final String message;

    DeleteAccountResponse({
      required this.status,
      required this.message,
    });

    factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
      return DeleteAccountResponse(
        status: json['status'] as bool,
        message: json['message'] as String,
      );
    }
  }