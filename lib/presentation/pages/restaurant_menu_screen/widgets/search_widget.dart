// search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_state.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_sheet.dart';

class SearchScreen extends StatefulWidget {
  final String? restaurantId;
  final List<MenuCategory> categories;

  const SearchScreen({
    super.key,
    required this.categories,
     this.restaurantId,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<SearchBloc>().add(
      SearchDishes(_searchController.text, widget.categories),
    );
  }

  bool _checkCalorieLimit(BuildContext context, double dishCalories) {
  // Get the current cart state
  final cartState = context.read<CartBloc>().state;
  
  // Get today's date for stats
  final today = DateTime.now();
  final todayDate = "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}";
  
  // Get the current state for user stats
  final state = context.read<RestaurantMenuBloc>().state;
  if (state is RestaurantMenuLoaded) {
    final userStats = state.menuResponse.userStats;
    final baseConsumedCalories = userStats.dailyConsumptionStats[todayDate] ?? 0.0;
    final dailyCalorieGoal = double.tryParse(userStats.dailyCalorieGoal) ?? 2000.0;
    
    // Calculate total calories if this dish is added
    final totalCaloriesAfterAdd = baseConsumedCalories + cartState.totalCalories + dishCalories;
    
    // Check if adding this dish would exceed the limit
    if (totalCaloriesAfterAdd > dailyCalorieGoal) {
      // Show warning message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Adding this item would exceed your daily calorie limit!',
            style: TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search foods...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                context.read<SearchBloc>().add(ClearSearch());
              },
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.error.isNotEmpty) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state.searchResults.isEmpty && _searchController.text.isNotEmpty) {
            return const Center(
              child: Text(
                'No results found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final dish = state.searchResults[index];
              return _buildDishItem(dish);
            },
          );
        },
      ),
    );
  }

Widget _buildDishItem(Dish dish) {
    final calories = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.calories.value} ${dish.servingInfos.first.servingInfo.nutritionFacts.calories.unit}'
        : 'N/A';
    final protein = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.protein.value} '
        : 'N/A';
    final carbs = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.carbs.value} '
        : 'N/A';

    // Helper function to create NutritionInfo from ServingInfo
    NutritionInfo createNutritionInfo(ServingDetails servingDetails) {
      return NutritionInfo(
        calories: double.tryParse(servingDetails.nutritionFacts.calories.value) ?? 0,
        protein: double.tryParse(servingDetails.nutritionFacts.protein.value) ?? 0,
        carbs: double.tryParse(servingDetails.nutritionFacts.carbs.value) ?? 0,
        fat: double.tryParse(servingDetails.nutritionFacts.totalFat.value) ?? 0,
        sodium: 0,
        sugar: 0,
        fiber: 0,
      );
    }

    // Create size options map from servingInfos
    Map<String, NutritionInfo> sizeOptions = {};
    for (var servingInfo in dish.servingInfos) {
      sizeOptions[servingInfo.servingInfo.size] =
          createNutritionInfo(servingInfo.servingInfo);
    }
        final defaultCalories = dish.servingInfos.isNotEmpty
      ? double.tryParse(dish.servingInfos.first.servingInfo.nutritionFacts.calories.value) ?? 0.0
      : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {

 if (_checkCalorieLimit(context, defaultCalories)) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: DishDetails(
                      calories: defaultCalories,
                      dishId: dish.id,
                      restaurantId: widget.restaurantId,
                      name: dish.dishName,
                      description: dish.description,
                      imageUrl: null,
                      servingSizes: dish.servingInfos
                          .map((info) => info.servingInfo.size)
                          .toList(),
                      sizeOptions: sizeOptions,
                      ingredients: const [],
                    ),
                  );
                },
              );
 }

            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      MaterialSymbols.fastfood_filled,
                      color: AppColors.buttonColors,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Dish Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.dishName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Calories Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.buttonColors,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                calories,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Protein Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "P$protein",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Carbs Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "C$carbs",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Add Button Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.buttonColors,
                          size: 34,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.7,
                                child: DishDetails(
                                  calories: defaultCalories,
                                  dishId: dish.id,
                                  restaurantId: widget.restaurantId,
                                  name: dish.dishName,
                                  description: dish.description,
                                  imageUrl: null,
                                  servingSizes: dish.servingInfos
                                      .map((info) => info.servingInfo.size)
                                      .toList(),
                                  sizeOptions: sizeOptions,
                                  ingredients: const [],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}
}