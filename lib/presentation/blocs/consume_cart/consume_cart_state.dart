import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_response.dart';

abstract class ConsumeCartState {}

class ConsumeCartInitial extends ConsumeCartState {}

class ConsumeCartLoading extends ConsumeCartState {}

class ConsumeCartSuccess extends ConsumeCartState {
  final ConsumeCartResponse response;

  ConsumeCartSuccess(this.response);
}

class ConsumeCartError extends ConsumeCartState {
  final String message;

  ConsumeCartError(this.message);
}