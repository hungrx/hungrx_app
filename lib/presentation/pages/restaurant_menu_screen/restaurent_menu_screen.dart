import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_event.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_state.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_state.dart';
import 'package:hungrx_app/presentation/blocs/manu_search/menu_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_event.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_event.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/food_cart_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/custom_expansion_panel.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/dish_details_sheet.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/progress_bar.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/widgets/search_widget.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final NearbyRestaurantModel? restaurant;
  final String? restaurantId;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurantId,
    this.restaurant,
  });

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  String? expandedCategory;
  String? expandedSubcategory;
  bool isLoading = false;
  bool isInitialLoad = true;
  RestaurantMenuResponse? _cachedMenuResponse;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // First try to load data from cache
    if (widget.restaurantId != null) {
      context.read<RestaurantMenuBloc>().add(
            LoadCachedRestaurantMenu(
              restaurantId: widget.restaurantId!,
            ),
          );
    }

    // Then fetch fresh data (the bloc will handle showing cached data first)
    _fetchMenuData();

    // Load other required data
    context.read<ProgressBarBloc>().add(FetchProgressBarData());
    context.read<GetCartBloc>().add(LoadCart());
  }

  void _fetchMenuData() {
    if (widget.restaurantId != null) {
      context.read<RestaurantMenuBloc>().add(
            LoadRestaurantMenu(
              restaurantId: widget.restaurantId!,
            ),
          );
    }
  }

  bool _checkCalorieLimit(BuildContext context, double dishCalories) {
    final getCartState = context.read<GetCartBloc>().state;
    final progressState = context.read<ProgressBarBloc>().state;

    if (progressState is ProgressBarLoaded) {
      // Get calories from ProgressBarBloc
      final baseConsumedCalories = progressState.data.totalCaloriesConsumed;
      final dailyCalorieGoal = progressState.data.dailyCalorieGoal;

      // Get calories from GetCartBloc
      double cartCalories = 0.0;
      if (getCartState is CartLoaded) {
        cartCalories = getCartState.totalNutrition['calories'] ?? 0.0;
      }

      // Calculate current total and remaining calories
      final currentTotal = baseConsumedCalories + cartCalories;
      final remainingCalories = dailyCalorieGoal - currentTotal;

      if (dishCalories > remainingCalories) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Warning: Adding this item (${dishCalories.round()} cal) would exceed your remaining calories (${remainingCalories.round()} cal)',
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
    } else if (progressState is ProgressBarError) {
      // Handle error state
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error checking calorie limit: ${progressState.message}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuExpansionBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: BlocConsumer<RestaurantMenuBloc, RestaurantMenuState>(
          listener: (context, state) {
            if (state is RestaurantMenuLoaded) {
              _cachedMenuResponse = state.menuResponse;
            } else if (state is RestaurantMenuError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is RestaurantMenuLoading && _cachedMenuResponse == null) {
              return const Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
              ));
            } else if (state is RestaurantMenuError &&
                _cachedMenuResponse == null) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.white)));
            }

            // Use cached data or new data
            final menuResponse = _cachedMenuResponse ??
                (state is RestaurantMenuLoaded ? state.menuResponse : null);

            if (menuResponse == null) {
              return const SizedBox();
            }

            return _buildContent(menuResponse);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Menu',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24 / textScaleFactor,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
      ),
      padding: EdgeInsets.all(horizontalPadding),
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
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[700]!,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Disclaimer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'HungrX is independent and not affiliated with restaurants. Content is for informational purposes only.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.buttonColors,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Nutritional values are approximate',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              final menuState = context.read<RestaurantMenuBloc>().state;
              if (menuState is RestaurantMenuLoaded) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => SearchBloc(),
                      child: SearchScreen(
                        restaurantId: widget.restaurantId,
                        categories: menuState.menuResponse.menu.categories,
                      ),
                    ),
                  ),
                );
              } else {
                // Show loading indicator or message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait while menu loads...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
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
                    'Search by name or calorie...',
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
          leftPadding: 16,
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
          backgroundColor: AppColors.tileColor,
          key: Key('${subCategory.id}-$parentCategoryId'),
          title: subCategory.subCategoryName,
          isExpanded: state.expandedSubcategoryId == subCategory.id &&
              state.expandedCategoryForSubcategory == parentCategoryId,
          onExpansionChanged: (isExpanded) {
            context.read<MenuExpansionBloc>().add(
                  ToggleSubcategory(parentCategoryId, subCategory.id),
                );
          },
          leftPadding: 25,
          fontSize: 12,
          children:
              subCategory.dishes.map((dish) => _buildMenuItem(dish)).toList(),
        );
      },
    );
  }

  Widget _buildMenuItem(Dish dish) {
    // Get screen metrics
    final screenWidth = MediaQuery.of(context).size.width;

    // Define responsive breakpoints
    final isExtraSmall = screenWidth < 320;
    final isSmall = screenWidth >= 320 && screenWidth < 375;
    final isMedium = screenWidth >= 375 && screenWidth < 428;
    // final isLarge = screenWidth >= 428;

    // Define responsive sizes
    final imageSize = screenWidth *
        (isExtraSmall
            ? 0.18
            : isSmall
                ? 0.2
                : 0.25);

    // Define responsive text sizes
    final titleFontSize = isExtraSmall
        ? 13.0
        : isSmall
            ? 14.0
            : isMedium
                ? 16.0
                : 17.0;
    final nutritionInfoFontSize = isExtraSmall
        ? 11.0
        : isSmall
            ? 13.0
            : 14.0;

    // Define responsive padding
    final tilePaddingHorizontal = screenWidth * (isExtraSmall ? 0.03 : 0.04);
    final tilePaddingVertical = screenWidth * (isExtraSmall ? 0.015 : 0.02);
    final contentPadding = screenWidth * (isExtraSmall ? 0.015 : 0.02);

    // Nutrition information
    final protein = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.protein.value} '
        : 'N/A';
    final carbs = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.carbs.value} '
        : 'N/A';

    // final getCartState = context.read<GetCartBloc>().state;
    // final menuState = context.read<RestaurantMenuBloc>().state;

    final defaultCalories = dish.servingInfos.isNotEmpty
        ? double.tryParse(dish.servingInfos.first.servingInfo.nutritionFacts
                .calories.value) ??
            0.0
        : 0.0;

    final calories = dish.servingInfos.isNotEmpty
        ? '${(double.tryParse(dish.servingInfos.first.servingInfo.nutritionFacts.calories.value) ?? 0).round()} ${dish.servingInfos.first.servingInfo.nutritionFacts.calories.unit}'
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
      padding: EdgeInsets.symmetric(
        horizontal: tilePaddingHorizontal,
        vertical: tilePaddingVertical,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.tileColor,
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
                _showDishDetails(context, dish, defaultCalories, sizeOptions);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Row(
                children: [
                  // Food image
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: dish.servingInfos.isNotEmpty &&
                              dish.servingInfos.first.servingInfo.url != null
                          ? Image.network(
                              dish.servingInfos.first.servingInfo.url!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.fastfood,
                                  color: Colors.grey,
                                  size: isExtraSmall
                                      ? 24
                                      : isSmall
                                          ? 28
                                          : 32,
                                );
                              },
                            )
                          : Icon(
                              Icons.fastfood,
                              color: Colors.grey,
                              size: isExtraSmall
                                  ? 24
                                  : isSmall
                                      ? 28
                                      : 32,
                            ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  // Dish information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.dishName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenWidth * 0.01),
                        Wrap(
                          spacing: screenWidth * 0.01,
                          runSpacing: screenWidth * 0.01,
                          children: [
                            // Calories info with BlocBuilder
                            BlocBuilder<GetCartBloc, GetCartState>(
                              builder: (context, getCartState) {
                                return BlocBuilder<ProgressBarBloc,
                                    ProgressBarState>(
                                  builder: (context, progressState) {
                                    double remainingCalories = 0.0;

                                    if (progressState is ProgressBarLoaded) {
                                      final baseConsumedCalories = progressState
                                          .data.totalCaloriesConsumed;
                                      final dailyCalorieGoal =
                                          progressState.data.dailyCalorieGoal;

                                      // Get calories from cart
                                      double cartCalories = 0.0;
                                      if (getCartState is CartLoaded) {
                                        cartCalories = getCartState
                                                .totalNutrition['calories'] ??
                                            0.0;
                                      }

                                      // Calculate remaining calories
                                      final currentTotal =
                                          baseConsumedCalories + cartCalories;
                                      remainingCalories =
                                          dailyCalorieGoal - currentTotal;
                                    }

                                    return _buildNutritionBadge(
                                      calories,
                                      defaultCalories > remainingCalories
                                          ? Colors.red
                                          : AppColors.buttonColors,
                                      nutritionInfoFontSize,
                                    );
                                  },
                                );
                              },
                            ),
                            _buildNutritionBadge("P$protein", Colors.white,
                                nutritionInfoFontSize),
                            _buildNutritionBadge(
                                "C$carbs", Colors.white, nutritionInfoFontSize),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  // Add button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: screenWidth * 0.01),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: AppColors.buttonColors,
                          size: isExtraSmall
                              ? 24
                              : isSmall
                                  ? 26
                                  : 28,
                        ),
                        onPressed: () {
                          if (_checkCalorieLimit(context, defaultCalories)) {
                            _showDishDetails(
                                context, dish, defaultCalories, sizeOptions);
                          }
                        },
                        padding: EdgeInsets.all(screenWidth * 0.005),
                        constraints: BoxConstraints(
                          minHeight: isExtraSmall ? 36 : 48,
                          minWidth: isExtraSmall ? 36 : 48,
                        ),
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

// Helper method to create nutrition badges
  Widget _buildNutritionBadge(String text, Color textColor, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

// Helper method to show dish details
  void _showDishDetails(BuildContext context, Dish dish, double defaultCalories,
      Map<String, NutritionInfo> sizeOptions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: DishDetails(
            servingInfos: dish.servingInfos,
            calories: defaultCalories,
            dishId: dish.id,
            restaurantId: widget.restaurantId,
            name: dish.dishName,
            description: dish.description,
            imageUrl: dish.servingInfos.isNotEmpty
                ? dish.servingInfos.first.servingInfo.url
                : null,
            servingSizes:
                dish.servingInfos.map((info) => info.servingInfo.size).toList(),
            sizeOptions: sizeOptions,
            ingredients: const [],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary(BuildContext context, UserStats userStats) {
    return BlocBuilder<GetCartBloc, GetCartState>(
      builder: (context, getCartState) {
        // Default values when cart isn't loaded yet
        double cartCalories = 0.0;
        int totalItems = 0;

        // Update values if cart is loaded
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

        return CalorieSummaryWidget(
          cartCalories: cartCalories,
          itemCount: totalItems,
          onViewOrderPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(
                  restaurant: widget.restaurant,
                ),
              ),
            );
            if (mounted) {
              context.read<GetCartBloc>().add(LoadCart());
            }
          },
          buttonColor: AppColors.buttonColors,
          primaryColor: AppColors.primaryColor,
        );
      },
    );
  }
}
