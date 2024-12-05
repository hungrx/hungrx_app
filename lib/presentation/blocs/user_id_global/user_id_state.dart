import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  final String? userId;

  const UserState(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserInitial extends UserState {
  const UserInitial() : super(null);
}

class UserLoaded extends UserState {
  const UserLoaded(super.userId);
}
