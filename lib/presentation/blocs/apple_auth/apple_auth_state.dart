import 'package:firebase_auth/firebase_auth.dart';

abstract class AppleAuthState {}

class AppleAuthInitial extends AppleAuthState {}

class AppleAuthLoading extends AppleAuthState {}

class AppleAuthSuccess extends AppleAuthState {
  final UserCredential credential;
  AppleAuthSuccess(this.credential);
}

class AppleAuthFailure extends AppleAuthState {
  final String error;
  AppleAuthFailure(this.error);
}
class AppleAuthCancelled extends AppleAuthState {}