import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_state.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_event.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';
import 'package:hungrx_app/routes/route_names.dart';

class BottomCalorieSearchWidget extends StatefulWidget {
  final String userId;

  final VoidCallback onSearchHistoryRefresh;
  final Color backgroundColor;
  final Color buttonColor;

  const BottomCalorieSearchWidget({
    super.key,
    required this.userId,
    required this.onSearchHistoryRefresh,
    this.backgroundColor = Colors.black,
    this.buttonColor = AppColors.buttonColors,
  });

  @override
  State<BottomCalorieSearchWidget> createState() =>
      _BottomCalorieSearchWidgetState();
}

class _BottomCalorieSearchWidgetState extends State<BottomCalorieSearchWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressBarBloc>().add(FetchProgressBarData());
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBarBloc, ProgressBarState>(
      builder: (context, state) {
        if (state is ProgressBarLoading) {
          return SizedBox();
        }

        if (state is ProgressBarError) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: widget.backgroundColor,
            child: Center(
              child: Text(
                'Error loading progress: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is ProgressBarLoaded) {
          final progress =
              (state.data.totalCaloriesConsumed / state.data.dailyCalorieGoal)
                  .clamp(0.0, 1.0);
          final progressColor = _getProgressColor(progress);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Calorie Progress',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${state.data.totalCaloriesConsumed.toInt()}',
                              style: TextStyle(
                                color: progressColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / ${state.data.dailyCalorieGoal.round()} cal',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress Bar
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.blueGrey.withOpacity(0.2),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(progressColor),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search Bar Section
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.buttonColors.withOpacity(0.5),
                          width: 0,
                        ),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        onTap: () {
                          context.pushNamed(RouteNames.grocerySeach).then((_) {
                            widget.onSearchHistoryRefresh();
                          });
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Search your food',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.buttonColors,
                            size: 24,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.buttonColors,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }

        // Default empty state
        return const SizedBox.shrink();
      },
    );
  }
}
