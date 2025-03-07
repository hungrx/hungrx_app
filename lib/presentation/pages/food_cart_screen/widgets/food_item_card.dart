import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';

class FoodItemCard extends StatelessWidget {
  final String cartId;
  final DishDetail dish;
  final Function(BuildContext, String) showCalorieWarning;

  const FoodItemCard({
    super.key,
    required this.cartId,
    required this.dish,
    required this.showCalorieWarning,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    final quantity = dish.quantity;
    final caloriesPerItem =
        double.tryParse(dish.nutritionInfo.calories.value) ?? 0;

    // Calculate responsive dimensions
    final double horizontalMargin = screenWidth * 0.04;
    final double verticalMargin = screenWidth * 0.02;
    final double padding = screenWidth * 0.03;
    final double imageSize = isSmallScreen ? 60.0 : 80.0;
    final double spacing = screenWidth * 0.04;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildFoodImage(imageSize, context),
              SizedBox(width: spacing),
              _buildFoodDetails(isSmallScreen),
              _buildQuantityControls(
                context,
                quantity ?? 1,
                caloriesPerItem,
                isSmallScreen,
              ),
            ],
          ),
        ),
        _buildDeleteButton(context, isSmallScreen),
      ],
    );
  }

  Widget _buildFoodImage(double size, BuildContext context) {
    // Create a unique key for the image based on the dish ID and URL
    final imageKey = ValueKey('${dish.url}');

    return Container(
      key: imageKey, // Add key to maintain widget state
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: dish.url != null
            ? Image.network(
                dish.url!,
                key: imageKey, // Add key to the image widget
                fit: BoxFit.cover,
                // Enable memory caching
                cacheWidth:
                    (size * MediaQuery.of(context).devicePixelRatio).round(),
                cacheHeight:
                    (size * MediaQuery.of(context).devicePixelRatio).round(),
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  // Add fade-in animation
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: child,
                  );
                },
                // Show loading indicator while image loads
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  );
                },
                // Handle errors gracefully
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading image: $error');
                  return Center(
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.grey,
                      size: size * 0.4,
                    ),
                  );
                },
              )
            : Center(
                child: Icon(
                  Icons.fastfood,
                  color: Colors.black,
                  size: size * 0.4,
                ),
              ),
      ),
    );
  }

  Widget _buildFoodDetails(bool isSmallScreen) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dish.dishName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${dish.nutritionInfo.calories.value} ${dish.nutritionInfo.calories.unit}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dish.restaurantName,
            style: TextStyle(
              color: Colors.green,
              fontSize: isSmallScreen ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(
    BuildContext context,
    int quantity,
    double caloriesPerItem,
    bool isSmallScreen,
  ) {
    final double iconSize = isSmallScreen ? 20 : 24;
    final double containerPadding = isSmallScreen ? 6 : 8;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.white,
            size: iconSize,
          ),
          constraints: BoxConstraints(
            minWidth: iconSize * 1.5,
            minHeight: iconSize * 1.5,
          ),
          padding: EdgeInsets.all(iconSize * 0.25),
          onPressed: quantity > 1
              ? () {
                  final state = context.read<GetCartBloc>().state;
                  if (state is CartLoaded) {
                    context.read<GetCartBloc>().add(
                          UpdateQuantity(
                            cartId: cartId,
                            dishId: dish.dishId,
                            quantity: quantity - 1,
                          ),
                        );
                  }
                }
              : null, // Disable button when quantity is 1
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: containerPadding,
            vertical: containerPadding * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
            size: iconSize,
          ),
          constraints: BoxConstraints(
            minWidth: iconSize * 1.5,
            minHeight: iconSize * 1.5,
          ),
          padding: EdgeInsets.all(iconSize * 0.25),
          onPressed: () {
            final state = context.read<GetCartBloc>().state;
            if (state is CartLoaded) {
              final newTotalCalories =
                  state.totalNutrition['calories']! + caloriesPerItem;

              if (newTotalCalories > state.remaining) {
                showCalorieWarning(
                  context,
                  'Adding more quantity would exceed your daily calorie limit!',
                );
              } else {
                context.read<GetCartBloc>().add(
                      UpdateQuantity(
                        cartId: cartId,
                        dishId: dish.dishId,
                        quantity: quantity + 1,
                      ),
                    );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, bool isSmallScreen) {
    final double buttonSize = isSmallScreen ? 20 : 24;

    return Positioned(
      top: -8,
      right: -2,
      child: IconButton(
        icon: Icon(
          Icons.cancel,
          color: AppColors.buttonColors,
          size: buttonSize,
        ),
        constraints: BoxConstraints(
          minWidth: buttonSize * 1.5,
          minHeight: buttonSize * 1.5,
        ),
        padding: EdgeInsets.all(buttonSize * 0.25),
        onPressed: () {
          context.read<DeleteDishCartBloc>().add(
                DeleteDishFromCart(
                  servingSize: dish.servingSize,
                  cartId: cartId,
                  restaurantId: dish.restaurantId,
                  dishId: dish.dishId,
                ),
              );
        },
      ),
    );
  }
}
