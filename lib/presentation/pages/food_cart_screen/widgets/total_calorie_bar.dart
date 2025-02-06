import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/meal_button.dart';

class TotalCaloriesBar extends StatelessWidget {
  final double remainingCalories;
  final Map<String, double> nutrition;

  const TotalCaloriesBar({
    super.key,
    required this.remainingCalories,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    
    final double horizontalPadding = screenWidth * 0.04;
    final double containerPadding = screenWidth * 0.035;
    final double borderRadius = screenWidth * 0.07;
    
    final currentCalories = nutrition['calories'] ?? 0.0;
    final isExceeded = currentCalories > remainingCalories;
    List<OrderDetail> orderDetails = [];

    final cartState = context.read<GetCartBloc>().state;
    if (cartState is CartLoaded) {
      orderDetails = cartState.carts.expand((cart) {
        return cart.dishDetails.map((dish) {
          return OrderDetail(
            dishId: dish.dishId,
            quantity: int.tryParse(dish.servingSize) ?? 1,
          );
        });
      }).toList();
    }

    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: containerPadding,
          vertical: containerPadding * 0.3,
        ),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          border: Border.all(
            color: isExceeded ? Colors.red : AppColors.buttonColors,
            width: isExceeded ? 1.0 : 0.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Calories ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${nutrition['calories']?.toStringAsFixed(0) ?? 0}',
                              style: TextStyle(
                                color: isExceeded
                                    ? Colors.red
                                    : AppColors.buttonColors,
                                fontSize: isSmallScreen ? 12 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                ' / ${remainingCalories.round().toString()} cal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                MealLoggerButton(
                  orderDetails: orderDetails,
                  totalCalories: '${nutrition['calories']?.toStringAsFixed(0) ?? 0}',
                  isEnabled: !isExceeded, // Pass the enabled state based on calories
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}