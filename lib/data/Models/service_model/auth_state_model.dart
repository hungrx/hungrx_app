class AuthState {
  final AuthStatus status;
  final String? userId;
  final bool requiresOnboarding;
  final bool isProfileComplete;
  final String? error;

  AuthState({
    required this.status,
    this.userId,
    this.requiresOnboarding = false,
    this.isProfileComplete = false,
    this.error,
  });
}

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  error,
}