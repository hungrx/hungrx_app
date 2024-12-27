import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_response_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponseModel response;

  const CartSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}