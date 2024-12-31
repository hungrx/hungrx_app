import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/cart_model.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/cart_api.dart';
import 'package:hungrx_app/data/repositories/cart_screen/cart_repository.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/meal_button.dart';

class CartScreen extends StatelessWidget {
  final double consumedCalories;
  const CartScreen({super.key, required this.consumedCalories});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCartBloc(
        CartRepository(CartApi()),
      )..add(
          LoadCart("677221b8e7e9a75db98b4d2c")), // Replace with actual userId
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
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.buttonColors,
                ),
              );
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
                              LoadCart("677221b8e7e9a75db98b4d2c"),
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
                              _buildCalorieSummaryCard(state.totalNutrition),
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
                              (context, index) {
                                final cart = state.carts[index];
                                return _buildFoodItem(
                                  context,
                                  cart.cartId,
                                  cart.dishDetails.first,
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

  Widget _buildCalorieSummaryCard(Map<String, double> nutrition) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Nutrition Facts ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          _buildNutritionInfo(nutrition),
          const SizedBox(height: 16),
          Row(
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
                  // Navigate to food selection screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(
    BuildContext context,
    String cartId,
    DishDetail dish,
  ) {
    final quantity = int.tryParse(dish.servingSize) ?? 1;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/pizz.png",
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[800],
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                ),
              );
            },
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Remove from cart functionality coming soon'),
                      ),
                    );
                  }
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
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
                  context.read<GetCartBloc>().add(
                        UpdateQuantity(
                          cartId: cartId,
                          dishId: dish.dishId,
                          quantity: quantity + 1,
                        ),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCaloriesBar(
    BuildContext context,
    Map<String, double> nutrition,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.buttonColors,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total Calories: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${nutrition['calories']?.toStringAsFixed(0) ?? 0} / ${consumedCalories.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const MealLoggerButton(),
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
        color: Colors.grey[800],
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
