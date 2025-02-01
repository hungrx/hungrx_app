import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/food_item_model.dart';
import 'package:hungrx_app/presentation/blocs/common_food_search/common_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/common_food_search/common_food_search_event.dart';
import 'package:hungrx_app/presentation/blocs/common_food_search/common_food_search_state.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_event.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_state.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_event.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/common_food_list.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/custom_food_dialog.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/meals_detail_sheet.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/shimmer_effect.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
context.read<ProgressBarBloc>().add(FetchProgressBarData()); // Ad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SearchBloc>().add(ClearSearch());
      }
    });
  }
  Color _getProgressColor(double progress) {
    if (progress <= 0.5) {
      return Colors.green;
    } else if (progress <= 0.75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _handleTabChange() {
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void _performSearch(String query) {
    if (_tabController.index == 0) {
      // Branded foods search
      context.read<SearchBloc>().add(PerformSearch(query));
    } else {
      context.read<CommonFoodSearchBloc>().add(CommonFoodSearchStarted(query));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<SearchBloc>().add(ClearSearch());
        context.read<CommonFoodSearchBloc>().add(CommonFoodSearchCleared());
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: _buildSearchField(context),
          bottom: TabBar(
            enableFeedback: true,
            controller: _tabController,
            indicatorColor: AppColors.buttonColors,
            labelColor: AppColors.buttonColors,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Branded Foods'),
              Tab(text: 'Common Foods'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _BrandedFoodsTab(),
                _CommonFoodsTab(),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildFloatingProgressBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingProgressBar() {
    return BlocBuilder<ProgressBarBloc, ProgressBarState>(
      builder: (context, state) {
        if (state is ProgressBarLoading) {
          return const SizedBox.shrink();
        }

        if (state is ProgressBarLoaded) {
          final progress = (state.data.totalCaloriesConsumed / 
                          state.data.dailyCalorieGoal).clamp(0.0, 1.0);
          final progressColor = _getProgressColor(progress);
          final remainingCalories = state.data.dailyCalorieGoal - state.data.totalCaloriesConsumed;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calories Today',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${state.data.totalCaloriesConsumed.toInt()}',
                              style: TextStyle(
                                color: progressColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / ${state.data.dailyCalorieGoal.round()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Remaining',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${remainingCalories.toInt()} cal',
                          style: TextStyle(
                            color: remainingCalories > 0 ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }


  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search foods...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: _performSearch,
      onChanged: (value) {
        if (value.isEmpty) {
          if (_tabController.index == 0) {
            context.read<SearchBloc>().add(ClearSearch());
          } else {
            context.read<CommonFoodSearchBloc>().add(CommonFoodSearchCleared());
          }
        }
      },
    );
  }
}

class _BrandedFoodsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return _buildLoader();
        } else if (state is SearchSuccess) {
          return _buildFoodList(context, state.foods);
        } else if (state is SearchError) {
          return _buildErrorState(context);
        }
        return EmptySearchState(
          icon: Icon(Icons.search, size: 48, color: Colors.grey[400]),
          message: 'Search for branded foods',
        );
      },
    );
  }
}

class _CommonFoodsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonFoodSearchBloc, CommonFoodSearchState>(
      builder: (context, state) {
        if (state is CommonFoodSearchLoading) {
          return const FoodListShimmer();
        } else if (state is CommonFoodSearchSuccess) {
          return CommonFoodList(foods: state.foods);
        } else if (state is CommonFoodSearchError) {
          return _buildErrorState(context);
        }
        return EmptySearchState(
          icon: Icon(Icons.search, size: 48, color: Colors.grey[400]),
          message: 'Search for common foods',
        );
      },
    );
  }
}

// Add this reusable widget
class EmptySearchState extends StatelessWidget {
  final Icon icon;
  final String message;

  const EmptySearchState({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoader() {
  return const FoodListShimmer();
}

Widget _buildErrorState(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.buttonColors,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Food Found!',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 70),
          _buildAddCustomFoodButton(context),
          const SizedBox(height: 5),
          _buildInfoText(),
        ],
      ),
    ),
  );
}

Widget _buildAddCustomFoodButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const CustomFoodDialog(),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.buttonColors,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Custom Food',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildInfoText() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline,
          color: Colors.red,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          "Can't find your food? Add it manually with its nutritional details!",
          style: TextStyle(
            overflow: TextOverflow.clip,
            color: Colors.grey[400],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFoodList(BuildContext context, List<FoodItemModel> foods) {
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: foods.length,
    itemBuilder: (context, index) {
      return _buildFoodItem(context, foods[index]);
    },
  );
}

Widget _buildFoodItem(BuildContext context, FoodItemModel food) {
  return BlocBuilder<ProgressBarBloc, ProgressBarState>(
    builder: (context, state) {
      bool isConsumable = true;
      Color calorieTextColor = Colors.green;
      
      if (state is ProgressBarLoaded) {
        final remainingCalories = state.data.dailyCalorieGoal - state.data.totalCaloriesConsumed;
        isConsumable = food.nutritionFacts.calories <= remainingCalories;
        calorieTextColor = isConsumable ? Colors.green : Colors.red;
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {
            if (!isConsumable) {
              _showCalorieWarning(context, food.nutritionFacts.calories);
            } else {
              _showMealDetailsBottomSheet(
                food,
                context,
                food.name,
                'serving size : ${food.servingInfo?.size ?? "unknown"} ${food.servingInfo?.unit ?? ""}',
              );
            }
          },
          contentPadding: const EdgeInsets.all(8),
          title: Text(
            food.name,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'serving size : ${food.servingInfo?.size ?? "unknown"} ${food.servingInfo?.unit ?? ""}',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                'Brand Name : ${food.brand}',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${food.nutritionFacts.calories.toStringAsFixed(1)} Cal',
                style: TextStyle(
                  color: calorieTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: isConsumable ? AppColors.buttonColors : Colors.grey,
                  size: 35,
                ),
                onPressed: isConsumable 
                  ? () => _showMealDetailsBottomSheet(
                      food,
                      context,
                      food.name,
                      'serving size : ${food.servingInfo?.size ?? "unknown"} ${food.servingInfo?.unit ?? ""}',
                    )
                  : () => _showCalorieWarning(context, food.nutritionFacts.calories),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showCalorieWarning(BuildContext context, double foodCalories) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Calorie Limit Warning',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This food item (${foodCalories.toStringAsFixed(1)} Cal) exceeds your remaining calorie limit for today.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColors,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Understood',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showMealDetailsBottomSheet(
  FoodItemModel food,
  BuildContext context,
  String name,
  String description,
) {
  final userState = context.read<UserBloc>().state;
  String? userId;

  if (userState is UserLoaded) {
    userId = userState.userId;
  }
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User not authenticated. Please login again.'),
        backgroundColor: Colors.red,
      ),
    );
    context.go('/login');
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is! UserLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
// ! changeaeeeeeee
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: MealDetailsBottomSheet(
                productId: food.id,
                userId: state.userId ?? "",
                calories: food.nutritionFacts.calories,
                mealName: name,
                servingInfo: description,
              ),
            ),
          );
        },
      );
    },
  );
}
