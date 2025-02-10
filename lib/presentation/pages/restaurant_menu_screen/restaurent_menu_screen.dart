import 'dart:convert';
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
import 'package:shared_preferences/shared_preferences.dart';

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
  RestaurantMenuResponse? _cachedMenuResponse;
  DateTime? _lastFetchTime;
  static const cacheDuration = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _loadCachedData();
    context.read<ProgressBarBloc>().add(FetchProgressBarData());
    context.read<GetCartBloc>().add(LoadCart());
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('menu_cache_${widget.restaurantId}');
    final lastFetchTimeStr =
        prefs.getString('menu_last_fetch_${widget.restaurantId}');

    if (cachedData != null && lastFetchTimeStr != null) {
      final lastFetchTime = DateTime.parse(lastFetchTimeStr);
      if (DateTime.now().difference(lastFetchTime) < cacheDuration) {
        try {
          final jsonData = json.decode(cachedData);
          setState(() {
            _cachedMenuResponse = RestaurantMenuResponse.fromJson(jsonData);
            _lastFetchTime = lastFetchTime;
          });
        } catch (e) {
          debugPrint('Error loading cached menu: $e');
        }
      }
    }

    // Fetch fresh data
    _fetchMenuData();
  }

  Future<void> _cacheData(RestaurantMenuResponse menuResponse) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('menu_cache_${widget.restaurantId}',
          json.encode(menuResponse.toJson()));
      await prefs.setString('menu_last_fetch_${widget.restaurantId}',
          DateTime.now().toIso8601String());
      _lastFetchTime = DateTime.now();
    } catch (e) {
      debugPrint('Error caching menu data: $e');
    }
  }

  void _fetchMenuData() {
    // Prevent frequent refetches
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) <
            const Duration(seconds: 30)) {
      return;
    }
    context.read<RestaurantMenuBloc>().add(
          LoadRestaurantMenu(
            restaurantId: widget.restaurantId ?? "",
          ),
        );
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
              // Cache new data only if it's different from cached data
              if (_cachedMenuResponse == null ||
                  !_areMenusEqual(
                      _cachedMenuResponse!.menu, state.menuResponse.menu)) {
                _cacheData(state.menuResponse);
                setState(() {
                  _cachedMenuResponse = state.menuResponse;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is RestaurantMenuLoading && _cachedMenuResponse == null) {
              return const Center(child: CircularProgressIndicator());
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

  bool _areMenusEqual(RestaurantMenu menu1, RestaurantMenu menu2) {
    if (menu1.id != menu2.id ||
        menu1.restaurantName != menu2.restaurantName ||
        menu1.categories.length != menu2.categories.length) {
      return false;
    }

    for (int i = 0; i < menu1.categories.length; i++) {
      final cat1 = menu1.categories[i];
      final cat2 = menu2.categories[i];
      if (cat1.id != cat2.id ||
          cat1.dishes.length != cat2.dishes.length ||
          cat1.subCategories.length != cat2.subCategories.length) {
        return false;
      }
    }

    return true;
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
    final protine = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.protein.value} '
        : 'N/A';
    final cards = dish.servingInfos.isNotEmpty
        ? '${dish.servingInfos.first.servingInfo.nutritionFacts.carbs.value} '
        : 'N/A';

    final getCartState = context.read<GetCartBloc>().state;
    final menuState = context.read<RestaurantMenuBloc>().state;

    // Calculate remaining calories
    if (menuState is RestaurantMenuLoaded) {
      // Get calories from cart
      if (getCartState is CartLoaded) {}

      // Calculate remaining calories
    }

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
    // final defaultCalories = dish.servingInfos.isNotEmpty
    //     ? double.tryParse(dish.servingInfos.first.servingInfo.nutritionFacts
    //             .calories.value) ??
    //         0.0
    //     : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

                                    return Container(
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
                                        style: TextStyle(
                                          // Change color to red if dish calories exceed remaining calories
                                          color: defaultCalories >
                                                  remainingCalories
                                              ? Colors.red
                                              : AppColors.buttonColors,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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
