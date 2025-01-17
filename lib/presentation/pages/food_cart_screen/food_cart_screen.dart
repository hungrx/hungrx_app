import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/get_cart_model.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_state.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/cart_shimmer.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/direction_button.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/meal_button.dart';
import 'package:hungrx_app/routes/route_names.dart';

class CartScreen extends StatefulWidget {
  final NearbyRestaurantModel? restaurant;

  const CartScreen({
    super.key,
    required this.restaurant,
  });
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<OrderDetail> orderDetails = [];
  @override
  void initState() {
    super.initState();
    context.read<GetCartBloc>().add(LoadCart());
  }

  void _showCalorieWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteDishCartBloc, DeleteDishCartState>(
      listener: (context, state) {
        if (state is DeleteDishCartSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the cart
          context.read<GetCartBloc>().add(LoadCart());
        } else if (state is DeleteDishCartError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            'Calorie Cart',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: BlocBuilder<GetCartBloc, GetCartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return _buildLoadingView();
            }
            if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GetCartBloc>().add(
                              LoadCart(),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColors,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CartLoaded && state.carts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add some delicious food to get started',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to restaurant screen
                            context.pushNamed(RouteNames.restaurants);
                          },
                          icon: const Icon(Icons.restaurant),
                          label: const Text(
                            'Show Restaurants',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColors,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to restaurant screen
                            context.pushNamed(RouteNames.dailyInsightScreen);
                          },
                          icon: const Icon(Icons.history),
                          label: const Text(
                            'See log history',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColors,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (state is CartLoaded) {
              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCalorieSummaryCard(
                                  state.remaining, state.totalNutrition),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Food Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (state.carts.isEmpty)
                        const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No items in cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, cartIndex) {
                                final cart = state.carts[cartIndex];
                                // Create a list of food items for each dish in the cart
                                return Column(
                                  children: cart.dishDetails.map((dish) {
                                    return _buildFoodItem(
                                      context,
                                      cart.cartId,
                                      dish,
                                    );
                                  }).toList(),
                                );
                              },
                              childCount: state.carts.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (state.carts.isNotEmpty)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildTotalCaloriesBar(
                        state.remaining,
                        context,
                        state.totalNutrition,
                      ),
                    ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const CartScreenShimmer();
  }

  Widget _buildCalorieSummaryCard(
      double remainingCalories, Map<String, double> nutrition) {
    final currentCalories = nutrition['calories'] ?? 0.0;
    final isExceeded = currentCalories > remainingCalories;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
        border: isExceeded ? Border.all(color: Colors.red, width: 1.0) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Nutrition Facts ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              if (isExceeded)
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
            ],
          ),
          if (isExceeded)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Daily calorie limit exceeded by ${(currentCalories - remainingCalories).toInt()} calories',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          _buildNutritionInfo(nutrition),
          const SizedBox(height: 10),
          // Information Section
          Column(
            children: [
              _buildInfoRow(
                icon: Icons.warning_rounded,
                text: 'Check restaurant for allergen information',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[900],
                      title: const Text(
                        'Allergen Information',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Please check with the respective restaurant for detailed allergen information. Food allergies and intolerances should be discussed with the restaurant staff before placing your order.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _buildInfoRow(
                icon: Icons.location_on_outlined,
                text:
                    'Dish availability varies by location of respective restaurant',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[900],
                      title: const Text(
                        'Location-based Availability',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Some dishes may not be available at certain locations due to seasonal ingredients, local preferences, or regional restrictions.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              context.pushNamed(RouteNames.restaurants);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Food',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppColors.buttonColors,
                      size: 30,
                    ),
                    onPressed: () {
                      context.pushNamed(RouteNames.restaurants);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AddressDirectionDialog(
                  restaurant: widget.restaurant,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Go to Restaurant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.directions,
                      color: AppColors.buttonColors,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AddressDirectionDialog(
                          restaurant: widget.restaurant,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for building info rows
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.redAccent,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(
    BuildContext context,
    String cartId,
    DishDetail dish,
  ) {
    final quantity = int.tryParse(dish.servingSize) ?? 1;
    final caloriesPerItem =
        double.tryParse(dish.nutritionInfo.calories.value) ?? 0;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  // Added ClipRRect to clip the image
                  borderRadius:
                      BorderRadius.circular(8), // Same radius as container
                  child: dish.servingSize.isNotEmpty
                      ? Image.network(
                          dish.url??"",
                          fit: BoxFit
                              .cover, // Changed to cover for better image filling
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.fastfood,
                                color: Colors.grey,
                                size: 32,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.dishName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${dish.nutritionInfo.calories.value} ${dish.nutritionInfo.calories.unit}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      dish.restaurantName,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (quantity > 1) {
                        context.read<GetCartBloc>().add(
                              UpdateQuantity(
                                cartId: cartId,
                                dishId: dish.dishId,
                                quantity: quantity - 1,
                              ),
                            );
                      }
                    },
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      final state = context.read<GetCartBloc>().state;
                      if (state is CartLoaded) {
                        final newTotalCalories =
                            state.totalNutrition['calories']! + caloriesPerItem;

                        if (newTotalCalories > state.remaining) {
                          _showCalorieWarning(
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
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -2,
          child: IconButton(
            icon: const Icon(
              Icons.cancel,
              color: AppColors.buttonColors,
              size: 24,
            ),
            onPressed: () {
              context.read<DeleteDishCartBloc>().add(
                    DeleteDishFromCart(
                      cartId: cartId,
                      restaurantId: dish.restaurantId,
                      dishId: dish.dishId,
                    ),
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCaloriesBar(
    double remainingCalories,
    BuildContext context,
    Map<String, double> nutrition,
  ) {
    final currentCalories = nutrition['calories'] ?? 0.0;
    final isExceeded = currentCalories > remainingCalories;
    final cartState = context.read<GetCartBloc>().state;

    // Calculate actual remaining calories
    // final actualRemainingCalories = remainingCalories - currentCalories;

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
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          border: Border.all(
            color: isExceeded ? Colors.red : AppColors.buttonColors,
            width: isExceeded ? 1.0 : 0.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Calories ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${nutrition['calories']?.toStringAsFixed(0) ?? 0}',
                          style: TextStyle(
                            color: isExceeded
                                ? Colors.red
                                : AppColors.buttonColors,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / ${remainingCalories.round().toString()} cal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                MealLoggerButton(
                  orderDetails: orderDetails,
                  totalCalories:
                      '${nutrition['calories']?.toStringAsFixed(0) ?? 0}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(Map<String, double> nutrition) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _nutritionItem(
            'Calories',
            nutrition['calories']?.toStringAsFixed(0) ?? '0',
          ),
          _nutritionItem(
            'Protein',
            nutrition['protein']?.toStringAsFixed(1) ?? '0',
            'g',
          ),
          _nutritionItem(
            'Carbs',
            nutrition['carbs']?.toStringAsFixed(1) ?? '0',
            'g',
          ),
          _nutritionItem(
            'Fat',
            nutrition['fat']?.toStringAsFixed(1) ?? '0',
            'g',
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem(String label, String value, [String? unit]) {
    String result = value.split('.')[0];
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unit != null ? '$result$unit' : result,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
