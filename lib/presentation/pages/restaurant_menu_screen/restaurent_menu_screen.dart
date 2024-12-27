import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_state.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_state.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_event.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';
import 'package:hungrx_app/presentation/pages/calorie_calculation_screen/calculation_tracking.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/progress_bar.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/search_widget.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final String? restaurantId;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  String? expandedCategory;
  String? expandedSubcategory;

  @override
  void initState() {
    super.initState();
    context.read<RestaurantMenuBloc>().add(
          LoadRestaurantMenu(
            restaurantId: widget.restaurantId ?? "",
          ),
        );
  }

@override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuExpansionBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
          builder: (context, state) {
            if (state is RestaurantMenuLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RestaurantMenuError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.white)));
            } else if (state is RestaurantMenuLoaded) {
              return _buildContent(state.menuResponse);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Menu',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContent(RestaurantMenuResponse menuResponse) {
    final menu = menuResponse.menu;

    final userStats = menuResponse.userStats;

    0.0;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildRestaurantInfoCard(menu),
                _buildMenuList(context, menu),
              ],
            ),
          ),
        ),
        _buildOrderSummary(context, userStats),
      ],
    );
  }

  Widget _buildRestaurantInfoCard(RestaurantMenu menu) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                menu.restaurantName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: AppColors.buttonColors, size: 16),
                    SizedBox(width: 4),
                    Text('4.2',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.access_time, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              Text('Open until 4:00 am', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SearchBloc(),
                    child: SearchScreen(
                      categories: (context.read<RestaurantMenuBloc>().state
                              as RestaurantMenuLoaded)
                          .menuResponse
                          .menu
                          .categories,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Search foods...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, RestaurantMenu menu) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menu.categories.length,
      itemBuilder: (context, index) {
        final category = menu.categories[index];
        return _buildMenuCategory(context, category);
      },
    );
  }

  Widget _buildMenuCategory(BuildContext context, MenuCategory category) {
    return BlocBuilder<MenuExpansionBloc, MenuExpansionState>(
      builder: (context, state) {
         debugPrint('Category ${category.id} - Expanded: ${state.expandedCategoryId == category.id}');
        return ExpansionTile(
          key: Key(category.id),
          initiallyExpanded: state.expandedCategoryId == category.id,
          onExpansionChanged: (isExpanded) {
            context.read<MenuExpansionBloc>().add(ToggleCategory(category.id));
          },
          title: Text(
            category.categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          backgroundColor: Colors.black,
          collapsedBackgroundColor: Colors.black,
          children: [
            ...category.dishes.map((dish) => _buildMenuItem(dish)),
            ...category.subCategories.map(
              (subCategory) =>
                  _buildSubcategory(context, category.id, subCategory),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubcategory(
    BuildContext context,
    String parentCategoryId,
    SubCategory subCategory,
  ) {
    return BlocBuilder<MenuExpansionBloc, MenuExpansionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ExpansionTile(
            key: Key('$parentCategoryId-${subCategory.id}'),
            initiallyExpanded: state.expandedSubcategoryId == subCategory.id &&
                state.expandedCategoryForSubcategory == parentCategoryId,
            onExpansionChanged: (isExpanded) {
              context.read<MenuExpansionBloc>().add(
                    ToggleSubcategory(parentCategoryId, subCategory.id),
                  );
            },
            title: Text(
              subCategory.subCategoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            backgroundColor: Colors.black,
            collapsedBackgroundColor: Colors.black,
            children:
                subCategory.dishes.map((dish) => _buildMenuItem(dish)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(Dish dish) {
    final calories = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.calories.value} ${dish.servingInfos.first.servingInfo.nutritionFacts.calories.unit}'
        : 'N/A';
    final protine = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.protein.value} '
        : 'N/A';
    final cards = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.carbs.value} '
        : 'N/A';

    // Helper function to create NutritionInfo from ServingInfo
    NutritionInfo createNutritionInfo(ServingDetails servingDetails) {
      return NutritionInfo(
        calories:
            int.tryParse(servingDetails.nutritionFacts.calories.value) ?? 0,
        protein:
            double.tryParse(servingDetails.nutritionFacts.protein.value) ?? 0,
        carbs: double.tryParse(servingDetails.nutritionFacts.carbs.value) ?? 0,
        fat: double.tryParse(servingDetails.nutritionFacts.totalFat.value) ?? 0,
        // Since these values aren't in your model, you might want to add them or handle differently
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Enables full-screen bottom sheet
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7, // Adjust height as needed
                    child: DishDetails(
                      name: dish.dishName,
                      description: dish.description,
                      // You might want to add an imageUrl field to your Dish model
                      imageUrl: null,
                      // Get all available serving sizes
                      servingSizes: dish.servingInfos
                          .map((info) => info.servingInfo.size)
                          .toList(),
                      sizeOptions: sizeOptions,
                      // If you have ingredients data, add it to your model
                      // For now, passing an empty list or you can add a default value
                      ingredients: const [],
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
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
                          spacing: 4,
                          children: [
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
                                "P$protine",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                "C$cards",
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
                            isScrollControlled:
                                true, // Enables full-screen bottom sheet
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.7, // Adjust height as needed
                                child: DishDetails(
                                  name: dish.dishName,
                                  description: dish.description,
                                  // You might want to add an imageUrl field to your Dish model
                                  imageUrl: null,
                                  // Get all available serving sizes
                                  servingSizes: dish.servingInfos
                                      .map((info) => info.servingInfo.size)
                                      .toList(),
                                  sizeOptions: sizeOptions,
                                  // If you have ingredients data, add it to your model
                                  // For now, passing an empty list or you can add a default value
                                  ingredients: const [],
                                ),
                              );
                            },
                          );
                          // Add to cart functionality
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

  Widget _buildOrderSummary(BuildContext context, UserStats userStats) {
    final todayDate = DateTime.now().toString().split(' ')[0];
    final baseConsumedCalories =
        userStats.dailyConsumptionStats[todayDate] ?? 0.0;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final totalConsumedCalories =
            baseConsumedCalories + cartState.totalCalories;

        return CalorieSummaryWidget(
          currentCalories: totalConsumedCalories,
          dailyCalorieTarget:
              double.tryParse(userStats.dailyCalorieGoal) ?? 2000.0,
          itemCount: cartState.items.length,
          onViewOrderPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalorieCalculationScreen(),
              ),
            );
          },
          buttonColor: AppColors.buttonColors,
          primaryColor: AppColors.primaryColor,
        );
      },
    );
  }
}
