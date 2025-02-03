import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // Get the current state for user stats
    final state = context.read<RestaurantMenuBloc>().state;
    if (state is RestaurantMenuLoaded) {
      final userStats = state.menuResponse.userStats;
      final baseConsumedCalories = userStats.todayConsumption;
      final dailyCalorieGoal =
          double.tryParse(userStats.dailyCalorieGoal) ?? 2000.0;

      // Calculate total calories if this dish is added
      final totalCaloriesAfterAdd =
          baseConsumedCalories + cartState.totalCalories + dishCalories;

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
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.08),
        child: AppBar(
          backgroundColor: Colors.black,
          title: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search foods...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              border: InputBorder.none,
         
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            );
          }

          if (state.searchResults.isEmpty &&
              _searchController.text.isNotEmpty) {
            return Center(
              child: Text(
                'No results found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final dish = state.searchResults[index];
              return _buildDishItem(dish, screenSize, isSmallScreen);
            },
          );
        },
      ),
    );
  }

  Widget _buildDishItem(Dish dish, Size screenSize, bool isSmallScreen) {
  return BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
    builder: (context, menuState) {
      if (menuState is! RestaurantMenuLoaded) {
        return const SizedBox();
      }

      final userStats = menuState.menuResponse.userStats;
      final dailyCalorieGoal = double.tryParse(userStats.dailyCalorieGoal) ?? 2000.0;
      final baseConsumedCalories = userStats.todayConsumption;
      
      // Get cart calories
      final cartState = context.watch<CartBloc>().state;
      final cartCalories = cartState.totalCalories;
      
      // Calculate remaining calories
      final remainingCalories = dailyCalorieGoal - (baseConsumedCalories + cartCalories);

      final defaultCalories = dish.servingInfos.isNotEmpty
          ? double.tryParse(dish.servingInfos.first.servingInfo.nutritionFacts.calories.value) ?? 0.0
          : 0.0;

      final isExceedingLimit = defaultCalories > remainingCalories;
      final calorieColor = isExceedingLimit ? Colors.red : Colors.green;

      final calories = dish.servingInfos.isNotEmpty
          ? '${dish.servingInfos.first.servingInfo.nutritionFacts.calories.value} ${dish.servingInfos.first.servingInfo.nutritionFacts.calories.unit}'
          : 'N/A';
      final protein = dish.servingInfos.isNotEmpty
          ? '${dish.servingInfos.first.servingInfo.nutritionFacts.protein.value} '
          : 'N/A';
      final carbs = dish.servingInfos.isNotEmpty
          ? '${dish.servingInfos.first.servingInfo.nutritionFacts.carbs.value} '
          : 'N/A';

      // Calculate responsive dimensions
      final imageSize = screenSize.width * 0.25;
      final horizontalPadding = screenSize.width * 0.04;
      final verticalPadding = screenSize.height * 0.01;

      Map<String, NutritionInfo> sizeOptions = {};
      for (var servingInfo in dish.servingInfos) {
        sizeOptions[servingInfo.servingInfo.size] = createNutritionInfo(servingInfo.servingInfo);
      }

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
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
                if (isExceedingLimit) {
                  _showCalorieLimitWarning(context, remainingCalories);
                } else {
                  _handleDishTap(dish, defaultCalories, sizeOptions);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(screenSize.width * 0.03),
                child: Row(
                  children: [
                    SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildDishImage(dish),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dish.dishName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              _buildNutritionTag(
                                calories, 
                                calorieColor,  // Use dynamic color based on limit
                                isSmallScreen
                              ),
                              _buildNutritionTag(
                                "P$protein",
                                AppColors.primaryColor,
                                isSmallScreen
                              ),
                              _buildNutritionTag(
                                "C$carbs",
                                AppColors.primaryColor,
                                isSmallScreen
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: isExceedingLimit ? Colors.grey : AppColors.buttonColors,
                            size: isSmallScreen ? 28 : 34,
                          ),
                          onPressed: isExceedingLimit
                              ? () => _showCalorieLimitWarning(context, remainingCalories)
                              : () => _handleDishTap(dish, defaultCalories, sizeOptions),
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
    },
  );
}
void _showCalorieLimitWarning(BuildContext context, double remainingCalories) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Calorie Limit Warning',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'This dish exceeds your remaining calorie limit for today (${remainingCalories.toStringAsFixed(1)} calories remaining).',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: AppColors.buttonColors)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

  Widget _buildDishImage(Dish dish) {
    return dish.servingInfos.first.servingInfo.url != null
        ? Image.network(
            dish.servingInfos.first.servingInfo.url!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.fastfood, color: Colors.grey, size: 32),
              );
            },
          )
        : const Center(
            child: Icon(Icons.fastfood, color: Colors.grey, size: 32),
          );
  }

  Widget _buildNutritionTag(String text, Color color, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == AppColors.buttonColors ? Colors.black : Colors.white,
          fontSize: isSmallScreen ? 12 : 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleDishTap(Dish dish, double defaultCalories,
      Map<String, NutritionInfo> sizeOptions) {
    if (_checkCalorieLimit(context, defaultCalories)) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.7,
          child: DishDetails(
            servingInfos: dish.servingInfos,
            calories: defaultCalories,
            dishId: dish.id,
            restaurantId: widget.restaurantId,
            name: dish.dishName,
            description: dish.description,
            imageUrl: null,
            servingSizes:
                dish.servingInfos.map((info) => info.servingInfo.size).toList(),
            sizeOptions: sizeOptions,
            ingredients: const [],
          ),
        ),
      );
    }
  }

  NutritionInfo createNutritionInfo(ServingDetails servingDetails) {
    return NutritionInfo(
      calories:
          double.tryParse(servingDetails.nutritionFacts.calories.value) ?? 0,
      protein:
          double.tryParse(servingDetails.nutritionFacts.protein.value) ?? 0,
      carbs: double.tryParse(servingDetails.nutritionFacts.carbs.value) ?? 0,
      fat: double.tryParse(servingDetails.nutritionFacts.totalFat.value) ?? 0,
      sodium: 0,
      sugar: 0,
      fiber: 0,
    );
  }
}
