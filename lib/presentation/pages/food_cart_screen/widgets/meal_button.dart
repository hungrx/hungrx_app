import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/meal_log_dialog.dart';

class MealLoggerButton extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double borderRadius;
  final String totalCalories;
  final List<OrderDetail> orderDetails;
  final bool isEnabled; // New parameter to control button state

  const MealLoggerButton({
    super.key,
    this.buttonText = 'Consume',
    this.buttonColor = AppColors.buttonColors,
    this.textColor = Colors.black,
    this.borderRadius = 20,
    required this.totalCalories,
    required this.orderDetails,
    required this.isEnabled, // Make it required
  });

  @override
  State<MealLoggerButton> createState() => _MealLoggerButtonState();
}

class _MealLoggerButtonState extends State<MealLoggerButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isEnabled ? () => _showMealLogDialog(context) : null, // Disable button when isEnabled is false
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isEnabled ? widget.buttonColor : Colors.grey, // Grey out when disabled
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: widget.isEnabled ? widget.textColor : Colors.white60, // Dim text when disabled
        ),
      ),
    );
  }

  void _showMealLogDialog(BuildContext context) {
    // print(widget.orderDetails.first.quantity);
    // print(widget.totalCalories);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MealLogDialog(
          orderDetails: widget.orderDetails,
          totalCalories: widget.totalCalories,
        );
      },
    );
  }
}

