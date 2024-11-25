

import 'package:firebase_auth/firebase_auth.dart';

abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  User user;

  GoogleAuthSuccess(this.user);
}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;

  GoogleAuthFailure({required this.error});
}
class GoogleAuthCancelled extends GoogleAuthState {}