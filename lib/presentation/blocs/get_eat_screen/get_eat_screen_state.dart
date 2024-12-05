import 'package:hungrx_app/data/Models/eat_screen_model.dart';

abstract class EatScreenState {}

class EatScreenInitial extends EatScreenState {}

class EatScreenLoading extends EatScreenState {}

class EatScreenLoaded extends EatScreenState {
  final EatScreenModel data;
  EatScreenLoaded(this.data);
}

class EatScreenError extends EatScreenState {
  final String message;
  EatScreenError(this.message);
}