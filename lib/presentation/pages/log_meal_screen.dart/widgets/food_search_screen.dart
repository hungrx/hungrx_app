import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/food_item_model.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_event.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_state.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/custom_food_dialog.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/meals_detail_sheet.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/shimmer_effect.dart';
import 'package:hungrx_app/routes/route_names.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SearchBloc>().add(ClearSearch());
      }
    });
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
      // Common foods search
      // context.read<SearchBloc>().add(PerformCommonFoodSearch(query));
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
              Tab(

                icon: SizedBox(),
                text: 'Branded Foods',
              ),
              Tab(
                icon: SizedBox(),
                text: 'Common Foods',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _BrandedFoodsTab(),
            _CommonFoodsTab(),
          ],
        ),
      ),
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
        return const Center(
          child: Text(
            'Search for branded foods...',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

class _CommonFoodsTab extends StatelessWidget {
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
        return const Center(
          child: Text(
            'Search for common foods...',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
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
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: AppColors.tileColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: food.image != null
            ? Image.network(
                food.image!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade800,
                    child: Icon(Icons.fastfood, color: Colors.grey.shade400),
                  );
                },
              )
            : Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade800,
                child: Icon(Icons.fastfood, color: Colors.grey.shade400),
              ),
      ),
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
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.buttonColors,
              size: 35,
            ),
            onPressed: () {
              _showMealDetailsBottomSheet(
                food,
                context,
                food.name,
                'serving size : ${food.servingInfo?.size ?? "unknown"} ${food.servingInfo?.unit ?? ""}',
              );
            },
          ),
        ],
      ),
      onTap: () {
        context.pushNamed(
          RouteNames.foodDetail,
          pathParameters: {'id': food.id},
          extra: {
            'isSearchScreen': false,
            'foodItem': food,
          },
        );
      },
    ),
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