import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_state.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_state.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_event.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/food_cart_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/custom_expansion_panel.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_sheet.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/progress_bar.dart';
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
    context.read<GetCartBloc>().add(LoadCart());
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
    // print("rest :${widget.restaurantId}");
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
                      restaurantId: widget.restaurantId,
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
        return CustomExpansionPanel(
          key: Key(category.id),
          title: category.categoryName,
          isExpanded: state.expandedCategoryId == category.id,
          onExpansionChanged: (isExpanded) {
            context.read<MenuExpansionBloc>().add(ToggleCategory(category.id));
          },
          children: [
            ...category.dishes.map((dish) => _buildMenuItem(dish)),
            ...category.subCategories.map(
              (subCategory) {
                return _buildSubcategory(context, category.id, subCategory);
              },
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
        return CustomExpansionPanel(
          backgroundColor: Colors.grey[900]!,
          key: Key('$parentCategoryId-${subCategory.id}'),
          title: subCategory.subCategoryName,
          isExpanded: state.expandedSubcategoryId == subCategory.id &&
              state.expandedCategoryForSubcategory == parentCategoryId,
          onExpansionChanged: (isExpanded) {
            context.read<MenuExpansionBloc>().add(
                  ToggleSubcategory(parentCategoryId, subCategory.id),
                );
          },
          leftPadding: 16,
          fontSize: 14,
          children:
              subCategory.dishes.map((dish) => _buildMenuItem(dish)).toList(),
        );
      },
    );
  }

  Widget _buildMenuItem(Dish dish) {
    // print("dish :${dish.id}");
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
            double.tryParse(servingDetails.nutritionFacts.calories.value) ?? 0,
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
    final defaultCalories = dish.servingInfos.isNotEmpty
        ? double.tryParse(dish.servingInfos.first.servingInfo.nutritionFacts
                .calories.value) ??
            0.0
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
                  isScrollControlled: true, // Enables full-screen bottom sheet
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.7, // Adjust height as needed
                      child: DishDetails(
                        servingInfos: dish.servingInfos,
                        calories: defaultCalories,
                        dishId: dish.id,
                        restaurantId: widget.restaurantId,
                        name: dish.dishName,
                        description: dish.description,
                        // You might want to add an imageUrl field to your Dish model
                        imageUrl: dish.servingInfos.isNotEmpty
                            ? dish.servingInfos.first.servingInfo.url
                            : null,
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
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      // Added ClipRRect to clip the image
                      borderRadius:
                          BorderRadius.circular(8), // Same radius as container
                      child: dish.servingInfos.first.servingInfo.url != null
                          ? Image.network(
                              dish.servingInfos.first.servingInfo.url!,
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
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                calories,
                                style: const TextStyle(
                                  color: AppColors.buttonColors,
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
                                color: Colors.grey[900],
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
                                color: Colors.grey[900],
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
                          Icons.add_circle_outline,
                          color: AppColors.buttonColors,
                          size: 30,
                        ),
                        onPressed: () {
                          if (_checkCalorieLimit(context, defaultCalories)) {
                            print(dish.servingInfos.isNotEmpty
                                ? dish.servingInfos.first.servingInfo.url
                                : null);

                            print("hei ");
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, // Enables full-screen bottom sheet
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.7, // Adjust height as needed
                                  child: DishDetails(
                                    servingInfos: dish.servingInfos,
                                    calories: defaultCalories,
                                    dishId: dish.id,
                                    restaurantId: widget.restaurantId,
                                    name: dish.dishName,
                                    description: dish.description,
                                    // You might want to add an imageUrl field to your Dish model
                                    imageUrl: dish.servingInfos.isNotEmpty
                                        ? dish
                                            .servingInfos.first.servingInfo.url
                                        : null,
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
                          }

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
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return BlocBuilder<GetCartBloc, GetCartState>(
          builder: (context, getCartState) {
            final baseConsumedCalories = userStats.todayConsumption;

            print(" base :${baseConsumedCalories}");

            final dailyCalorieGoal =
                double.tryParse(userStats.dailyCalorieGoal) ?? 2000.0;

            int totalItems = 0;
            double cartCalories = 0.0;

            if (getCartState is CartLoaded) {
              totalItems = getCartState.carts.fold<int>(
                0,
                (sum, cart) =>
                    sum +
                    cart.dishDetails.fold<int>(
                      0,
                      (dishSum, dish) =>
                          dishSum + (int.tryParse(dish.servingSize) ?? 1),
                    ),
              );

              cartCalories = getCartState.totalNutrition['calories'] ?? 0.0;
            }

            // ! i have added the totla consumedCalories plus the total caloriees in the cart
            // ! pass the total item count from the cart screen

            final totalConsumedCalories =
                baseConsumedCalories + cartState.totalCalories + cartCalories;
            final cartcount = cartState.items.length;

            final totalItemCount = cartcount + totalItems;

            return CalorieSummaryWidget(
              currentCalories: totalConsumedCalories,
              remainingDailyCalorie: dailyCalorieGoal,
              itemCount: totalItemCount,
              onViewOrderPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              buttonColor: AppColors.buttonColors,
              primaryColor: AppColors.primaryColor,
            );
          },
        );
      },
    );
  }
}
