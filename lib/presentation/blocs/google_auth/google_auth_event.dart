import 'package:equatable/equatable.dart';

abstract class GoogleAuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends GoogleAuthEvent {

}

class GoogleSignOutRequested extends GoogleAuthEvent {}