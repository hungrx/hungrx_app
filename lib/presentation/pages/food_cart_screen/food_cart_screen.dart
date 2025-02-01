import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_state.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/cart_shimmer.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/direction_button.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/food_item_card.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/total_calorie_bar.dart';
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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final bool isSmallScreen = screenWidth < 360;
    return BlocListener<DeleteDishCartBloc, DeleteDishCartState>(
      listener: (context, state) {
        if (state is DeleteDishCartSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
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
          title: Text(
            'Calorie Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 20 : 24,
            ),
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: isSmallScreen ? 48 : 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: screenWidth * 0.04),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      Text(
                        'Add some delicious food to get started',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenWidth * 0.06),
                      Wrap(
                        spacing: screenWidth * 0.04,
                        runSpacing: screenWidth * 0.03,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildActionButton(
                            context: context,
                            icon: Icons.restaurant,
                            label: 'Show restaurants',
                            onPressed: () =>
                                context.pushNamed(RouteNames.restaurants),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                          ),
                          _buildActionButton(
                            context: context,
                            icon: Icons.history,
                            label: 'See log history',
                            onPressed: () => context
                                .pushNamed(RouteNames.dailyInsightScreen),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                          ),
                        ],
                      ),
                    ],
                  ),
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
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCalorieSummaryCard(
                                state.remaining,
                                state.totalNutrition,
                                screenWidth,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Text(
                            'Food Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 16 : 18,
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
                                    return FoodItemCard(
                            
                                      cartId: cart.cartId,
                                      dish: dish,
                                      showCalorieWarning: _showCalorieWarning,
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
                      child: TotalCaloriesBar(
                        remainingCalories: state.remaining,
                        nutrition: state.totalNutrition,
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

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isSmallScreen,
    required double screenWidth,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: isSmallScreen ? 20 : 24,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: isSmallScreen ? 12 : 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColors,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.02,
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const CartScreenShimmer();
  }

  Widget _buildCalorieSummaryCard(
    double remainingCalories,
    Map<String, double> nutrition,
    double screenWidth,
  ) {
    final currentCalories = nutrition['calories'] ?? 0.0;
    final isExceeded = currentCalories > remainingCalories;
    final bool isSmallScreen = screenWidth < 360;
    final double cardPadding = screenWidth * 0.04;

    return Container(
      padding: EdgeInsets.all(cardPadding),
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
              Text(
                'Total Nutrition Facts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 18 : 20,
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
          _buildNutritionInfo(nutrition, screenWidth),
          SizedBox(height: screenWidth * 0.02),
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

  Widget _buildNutritionInfo(
      Map<String, double> nutrition, double screenWidth) {
    final bool isSmallScreen = screenWidth < 360;
    final double itemWidth = (screenWidth - (screenWidth * 0.24)) / 4;

    return Padding(
      padding: EdgeInsets.only(top: screenWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _nutritionItem(
              'Calories',
              nutrition['calories']?.toStringAsFixed(0) ?? '0',
              itemWidth,
              isSmallScreen),
          _nutritionItem(
              'Protein',
              nutrition['protein']?.toStringAsFixed(1) ?? '0',
              itemWidth,
              isSmallScreen,
              'g'),
          _nutritionItem('Carbs', nutrition['carbs']?.toStringAsFixed(1) ?? '0',
              itemWidth, isSmallScreen, 'g'),
          _nutritionItem('Fat', nutrition['fat']?.toStringAsFixed(1) ?? '0',
              itemWidth, isSmallScreen, 'g'),
        ],
      ),
    );
  }

  Widget _nutritionItem(
      String label, String value, double width, bool isSmallScreen,
      [String? unit]) {
    String result = value.split('.')[0];
    return Container(
      width: width,
      height: width,
      padding: EdgeInsets.all(width * 0.15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unit != null ? '$result$unit' : result,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: width * 0.05),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
