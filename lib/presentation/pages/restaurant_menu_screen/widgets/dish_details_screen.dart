import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_event.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_state.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_event.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_state.dart';

class DishDetails extends StatefulWidget {
  final String? dishId;
  final String? restaurantId;
  final String name;
  final String? imageUrl;
  final String description;
  final List<String> servingSizes;
  final Map<String, NutritionInfo> sizeOptions;
  final List<String> ingredients;

  const DishDetails({
    super.key,
    required this.name,
    this.imageUrl,
    required this.description,
    required this.servingSizes,
    required this.sizeOptions,
    required this.ingredients,
    this.restaurantId,
    this.dishId,
  });

  @override
  State<DishDetails> createState() => _DishDetailsState();
}

class _DishDetailsState extends State<DishDetails> {
  
  void _handleAddToCart(BuildContext context) {
    if (widget.dishId == null || widget.restaurantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid dish or restaurant information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartRequest = CartRequest(
      // No need to provide userId here
      orders: [
        CartOrderRequest(
          restaurantId: widget.restaurantId!,
          items: [
            CartItemRequest(
              dishId: widget.dishId!,
              servingSize: selectedSize,
            ),
          ],
        ),
      ],
    );

    context.read<AddToCartBloc>().add(SubmitAddToCartEvent(cartRequest));

    final nutrition = _calculateTotalNutrition();
    final cartItem = CartItem(
      dishName: widget.name,
      size: selectedSize,
      nutritionInfo: nutrition,
    );

    // Dispatch the AddToCart event to update the progress bar
    context.read<CartBloc>().add(AddToCart(cartItem));
  }

  String selectedSize = '';

  @override
  void initState() {
    super.initState();
    // Set default size to first available option
    if (widget.sizeOptions.isNotEmpty) {
      selectedSize = widget.sizeOptions.keys.first;
    }
  }

  NutritionInfo _calculateTotalNutrition() {
    return widget.sizeOptions[selectedSize]!;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.description);
    final nutrition = _calculateTotalNutrition();

    return BlocListener<AddToCartBloc, AddToCartState>(
      listener: (context, state) {
        if (state is AddToCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.response.message)),
          );
        } else if (state is AddToCartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                      const SizedBox(height: 16),
                      _buildServingSizes(),
                      const SizedBox(height: 16),
                      _buildNutritionInfo(nutrition),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(nutrition),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: 
            
            Container(
                color: Colors.white,
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.description,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
  }

  Widget _buildServingSizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Serving Size:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.servingSizes.map((size) {
            final isSelected = size == selectedSize;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSize = size;
                });
              },
              child: Chip(
                label: Text(
                  size,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                backgroundColor:
                    isSelected ? AppColors.buttonColors : Colors.grey[900],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(NutritionInfo nutrition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _nutritionItem('Calories', '${nutrition.calories}'),
            _nutritionItem('Protein', '${nutrition.protein}g'),
            _nutritionItem('Carbs', '${nutrition.carbs}g'),
            _nutritionItem('Fat', '${nutrition.fat}g'),
          ],
        ),
      ],
    );
  }

  Widget _nutritionItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
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
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

// In _buildBottomBar method of DishDetails widget
  Widget _buildBottomBar(NutritionInfo nutrition) {
    return BlocBuilder<AddToCartBloc, AddToCartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColors,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: state is AddToCartLoading
                ? null
                : () {
                  print(widget.dishId);
                  print(widget.restaurantId);
                    _handleAddToCart(context);
                    Navigator.pop(context);
                  },
            child: state is AddToCartLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Text(
                    'Add to Meal (${nutrition.calories} Calories)',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class NutritionInfo {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int sodium;
  final double sugar;
  final double fiber;

  const NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.fiber,
  });
}
