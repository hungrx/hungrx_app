import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserId extends UserEvent {}

class UpdateUserId extends UserEvent {
  final String? userId;

  UpdateUserId(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClearUserId extends UserEvent {}