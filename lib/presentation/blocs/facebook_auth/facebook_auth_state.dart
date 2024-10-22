abstract class FacebookAuthState {}

class FacebookAuthInitial extends FacebookAuthState {}

class FacebookAuthLoading extends FacebookAuthState {}

class FacebookAuthSuccess extends FacebookAuthState {
  final String token;

  FacebookAuthSuccess(this.token);
}

class FacebookAuthFailure extends FacebookAuthState {
  final String error;

  FacebookAuthFailure(this.error);
}