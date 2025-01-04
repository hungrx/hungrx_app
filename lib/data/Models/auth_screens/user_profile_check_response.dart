class UserProfileCheckResponse {
  final bool status;
  final ProfileCheckData data;

  UserProfileCheckResponse({
    required this.status,
    required this.data,
  });

  factory UserProfileCheckResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileCheckResponse(
      status: json['status'] ?? false,
      data: ProfileCheckData.fromJson(json['data']),
    );
  }
}

class ProfileCheckData {
  final String message;

  ProfileCheckData({required this.message});

  factory ProfileCheckData.fromJson(Map<String, dynamic> json) {
    return ProfileCheckData(
      message: json['message'] ?? '',
    );
  }
}