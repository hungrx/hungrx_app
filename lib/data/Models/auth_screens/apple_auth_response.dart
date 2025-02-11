class AppleAuthResponse {
  final bool status;
  final AppleAuthData data;

  AppleAuthResponse({required this.status, required this.data});

  factory AppleAuthResponse.fromJson(Map<String, dynamic> json) {
    return AppleAuthResponse(
      status: json['status'] as bool,
      data: AppleAuthData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class AppleAuthData {
  final String message;
  final String? token;
  final AppleUser? user;

  AppleAuthData({required this.message, this.token, this.user});

  factory AppleAuthData.fromJson(Map<String, dynamic> json) {
    return AppleAuthData(
      message: json['message'] as String,
      token: json['token'] as String?,
      user: json['user'] != null ? AppleUser.fromJson(json['user']) : null,
    );
  }
}

class AppleUser {
  final String id;
  final String email;
  final String name;

  AppleUser({required this.id, required this.email, required this.name});

  factory AppleUser.fromJson(Map<String, dynamic> json) {
    return AppleUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }
}