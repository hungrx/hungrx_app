import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';

abstract class ConsumeCartEvent {}

class ConsumeCartSubmitted extends ConsumeCartEvent {
  final String mealType;
  final List<OrderDetail> orderDetails;

  ConsumeCartSubmitted({
    required this.mealType,
    required this.orderDetails,
  });
}