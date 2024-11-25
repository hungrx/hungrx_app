abstract class ProfileCheckState {}

class ProfileCheckInitial extends ProfileCheckState {}

class ProfileCheckLoading extends ProfileCheckState {}

class ProfileCheckComplete extends ProfileCheckState {
  final bool isProfileComplete;
  ProfileCheckComplete(this.isProfileComplete);
}

class ProfileCheckError extends ProfileCheckState {
  final String message;
  ProfileCheckError(this.message);
}