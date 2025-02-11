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
      user: json['user'] != null ? AppleUser.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }
}

class AppleUser {
  final String id;
  final String email;
  final String? name; // Made name optional

  AppleUser({
    required this.id, 
    required this.email, 
    this.name, // Remove required keyword
  });

  factory AppleUser.fromJson(Map<String, dynamic> json) {
    return AppleUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?, // Make it nullable
    );
  }
}