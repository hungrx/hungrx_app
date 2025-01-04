import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/cart_request.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_event.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_state.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_event.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_state.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';

class DishDetails extends StatefulWidget {
  final double calories;
  final String? dishId;
  final String? restaurantId;
  final String name;
  final String? imageUrl;
  final String description;
  final List<String> servingSizes;
   final List<ServingInfo> servingInfos; 
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
    required this.calories, required this.servingInfos,
  });

  @override
  State<DishDetails> createState() => _DishDetailsState();
}

class _DishDetailsState extends State<DishDetails> {
  bool _checkCalorieLimit(BuildContext context, double dishCalories) {
    final cartState = context.read<CartBloc>().state;
    final menuState = context.read<RestaurantMenuBloc>().state;

    if (menuState is RestaurantMenuLoaded) {
      final userStats = menuState.menuResponse.userStats;
      final baseConsumedCalories =
          userStats.todayConsumption;
      final dailyCalorieGoal =
          double.tryParse(userStats.dailyCalorieGoal) ?? 2000.0;
      final totalCaloriesAfterAdd =
          baseConsumedCalories + cartState.totalCalories + dishCalories;

      if (totalCaloriesAfterAdd > dailyCalorieGoal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Warning: Adding this item (${dishCalories.toInt()} cal) would exceed your daily limit of ${dailyCalorieGoal.toInt()} calories',
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
        return false;
      }
    }
    return true;
  }

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

  final nutrition = _calculateTotalNutrition();
  
  if (_checkCalorieLimit(context, nutrition.calories)) {  // Use calculated calories
    final cartRequest = CartRequest(
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

    final cartItem = CartItem(
      dishName: widget.name,
      size: selectedSize,
      nutritionInfo: nutrition,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));
  }
}

  String selectedSize = '';
  late ServingInfo selectedServingInfo;

  @override
  void initState() {
    super.initState();
    // Set default size to first available option
    if (widget.sizeOptions.isNotEmpty) {
       selectedServingInfo = widget.servingInfos.first;
      selectedSize = widget.sizeOptions.keys.first;
    }
  }
   void _updateSelectedSize(String size) {
    setState(() {
      selectedSize = size;
      selectedServingInfo = widget.servingInfos.firstWhere(
        (info) => info.servingInfo.size == size,
        orElse: () => widget.servingInfos.first,
      );
    });
  }

  NutritionInfo _calculateTotalNutrition() {
    final facts = selectedServingInfo.servingInfo.nutritionFacts;
    return NutritionInfo(
      calories: double.tryParse(facts.calories.value) ?? 0,
      protein: double.tryParse(facts.protein.value) ?? 0,
      carbs: double.tryParse(facts.carbs.value) ?? 0,
      fat: double.tryParse(facts.totalFat.value) ?? 0,
      sodium: 0, // Add if available in your model
      sugar: 0,  // Add if available in your model
      fiber: 0,  // Add if available in your model
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = _calculateTotalNutrition();

    return BlocListener<AddToCartBloc, AddToCartState>(
      listener: (context, state) {
        if (state is AddToCartSuccess) {
          Navigator.pop(context);
           context.read<GetCartBloc>().add(LoadCart());
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
final currentImageUrl = selectedServingInfo.servingInfo.url;
// final currentServingInfo = widget.sizeOptions.entries
//       .firstWhere((entry) => entry.key == selectedSize,
//           orElse: () => widget.sizeOptions.entries.first);
      
  // Get the URL for the current size
  // final currentImageUrl = widget.sizeOptions[selectedSize]?.imageUrl ?? widget.imageUrl;
  // final currentImageUrl = widget.servingSizes.isNotEmpty
  //     ? widget.sizeOptions[selectedSize]?.imageUrl
  //     : null;
print(currentImageUrl);
  return SliverAppBar(
    leading: const SizedBox(),
    expandedHeight: 200,
    pinned: true,
    backgroundColor: Colors.white,
    flexibleSpace: FlexibleSpaceBar(
      background: currentImageUrl != null && currentImageUrl.isNotEmpty 
          ? Image.network(
              currentImageUrl,
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading image: $error"); 
                return _buildFallbackIcon();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.buttonColors,
                  ),
                );
              },
            )
          : _buildFallbackIcon(),
    ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 100,
          color: Colors.grey[400],
        ),
      ),
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
          children: widget.servingInfos.map((servingInfo) {
            final size = servingInfo.servingInfo.size;
            final isSelected = size == selectedSize;
            return GestureDetector(
              onTap: () {
                _updateSelectedSize(size);
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
            _nutritionItem('Calories', '${nutrition.calories.round()}'),
            _nutritionItem('Protein', '${nutrition.protein.round()}g'),
            _nutritionItem('Carbs', '${nutrition.carbs.round()}g'),
            _nutritionItem('Fat', '${nutrition.fat.round()}g'),
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
                    _handleAddToCart(context);
                  },
            child: state is AddToCartLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
                    ),
                  )
                : Text(
                    'Add to Meal (${nutrition.calories.round()} Calories)',
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
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final int sodium;
  final double sugar;
  final double fiber;
  final String? imageUrl;  // Add this field

  const NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.fiber,
    this.imageUrl,  // Add this parameter
  });
}
