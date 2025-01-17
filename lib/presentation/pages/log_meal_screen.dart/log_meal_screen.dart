import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/get_search_history_log_response.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_event.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_event.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_state.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/bottom_search_bar.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/meals_detail_sheet.dart';

class LogMealScreen extends StatelessWidget {
  const LogMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return LogMealView(userId: userState.userId ?? "");
        }
        // Show loading or redirect to login if user is not authenticated
        return const SizedBox();
      },
    );
  }
}

class LogMealView extends StatefulWidget {
  final String userId;
  const LogMealView({super.key, required this.userId});

  @override
  State<LogMealView> createState() => _LogMealViewState();
}

class _LogMealViewState extends State<LogMealView> {
  @override
  void initState() {
    super.initState();
    // Trigger search history refresh when screen loads
    context.read<SearchHistoryLogBloc>().add(
          GetSearchHistoryLogRequested(),
        );
    context.read<ProgressBarBloc>().add(FetchProgressBarData());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Log your meal',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildSearchBar(context),
                    _buildHistoryHeader(),
                    _buildFoodList(),
                    //  const SizedBox(height: 180),
                  ],
                ),
              ),
            ),
            // _buildOrderSummary(context),
            BottomCalorieSearchWidget(
              userId: widget.userId,
              onSearchHistoryRefresh: () {
                context.read<SearchHistoryLogBloc>().add(
                      GetSearchHistoryLogRequested(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildOrderSummary(BuildContext context) {
  //   return     BottomCalorieSearchWidget(
  //             currentCalories:
  //                 1500, // Replace with actual values from your state
  //             remainingDailyCalorie:
  //                 2000, // Replace with actual values from your state
  //             userId: widget.userId,
  //             onSearchHistoryRefresh: () {
  //               context.read<SearchHistoryLogBloc>().add(
  //                     GetSearchHistoryLogRequested(),
  //                   );
  //             },
  //           );

  // }

  Widget _buildHistoryHeader() {
    return BlocBuilder<SearchHistoryLogBloc, SearchHistoryLogState>(
      builder: (context, state) {
        final currentSortOption = state is SearchHistoryLogSuccess
            ? state.currentSortOption
            : 'Recently Added';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Search History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: currentSortOption,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: AppColors.buttonColors),
                  style: const TextStyle(color: Colors.grey),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<SearchHistoryLogBloc>().add(
                            SortSearchHistoryLogRequested(sortOption: newValue),
                          );
                    }
                  },
                  items: <String>[
                    'Recently Added',
                    'Alphabetical',
                    'Calories: High to Low',
                    'Calories: Low to High'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodList() {
    return BlocBuilder<SearchHistoryLogBloc, SearchHistoryLogState>(
      builder: (context, state) {
        if (state is SearchHistoryLogLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.buttonColors),
          );
        }

        if (state is SearchHistoryLogFailure) {
          return const Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 25,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Some Error Occurred',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is SearchHistoryLogSuccess) {
          if (state.items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 200),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 40,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Search History Available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your recent food searches will appear here',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              // print("brand:${item.name}");
              // print("naemd:${item.name}");
              // print("size:${item.servingInfo.size}");
              // print(item.image);
              // print(item.nutritionFacts.calories);

              return _buildFoodItem(
                context: context,
                foodItem: item,
                name: item.name,
                description:
                    '${item.servingInfo.size} ${item.servingInfo.unit}',
                calories:
                    '${item.nutritionFacts.calories?.toStringAsFixed(1) ?? "N/A"} Cal.',
                brandName: item.brandName,
                imageUrl: item.image,
                onTap: () {},
              );
            },
          );
        }

        // Default case when state is not handled
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFoodItem({
    required BuildContext context,
    required GetSearchHistoryLogItem foodItem,
    required String name,
    required String description,
    required String calories,
    required String brandName,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            name,
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
                'serving size : $description',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                'Brand Name : $brandName',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                calories,
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
                    foodItem,
                    context,
                    foodItem.name,
                    '${foodItem.servingInfo.size} ${foodItem.servingInfo.unit}',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMealDetailsBottomSheet(
    GetSearchHistoryLogItem foodItem,
    BuildContext context,
    String name,
    String description,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        // print("print logefood:${foodItem.foodId}");

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: MealDetailsBottomSheet(
              isHistoryScreen: true,
              productId: foodItem.foodId,
              userId: widget.userId,
              calories: foodItem.nutritionFacts.calories ?? 0,
              mealName: name,
              servingInfo: description,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        debugPrint(
          'Servings: ${value['servings']}, Serving Size: ${value['servingSize']}',
        );
      }
    });
  }
}
