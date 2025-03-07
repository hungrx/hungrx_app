import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/common_consume_sheet.dart';

class CommonFoodListItem extends StatefulWidget {
  final CommonFoodModel food;

  const CommonFoodListItem({
    super.key,
    required this.food,
  });

  @override
  State<CommonFoodListItem> createState() => _CommonFoodListItemState();
}

class _CommonFoodListItemState extends State<CommonFoodListItem> {
  final _authService = AuthService();
  String userId = "";

  Future<void> _initializeUserId() async {
    userId = await _authService.getUserId() ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBarBloc, ProgressBarState>(
      builder: (context, state) {
        bool isWithinLimit = true;
        if (state is ProgressBarLoaded) {
          final remainingCalories =
              state.data.dailyCalorieGoal - state.data.totalCaloriesConsumed;
          isWithinLimit =
              widget.food.nutritionFacts.calories <= remainingCalories;
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: () {
              if (!isWithinLimit) {
                _showCalorieWarning(context);
              } else {
                _showMealDetailsBottomSheet(
                  context,
                  widget.food,
                  widget.food.name,
                  'serving size : ${widget.food.servingInfo.size} ${widget.food.servingInfo.unit}',
                );
              }
            },
            contentPadding: const EdgeInsets.all(8),
            title: Text(
              widget.food.name,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'serving size : ${widget.food.servingInfo.size} ${widget.food.servingInfo.unit}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                Text(
                  widget.food.category.main,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.food.nutritionFacts.calories.toStringAsFixed(1)} Cal',
                  style: TextStyle(
                    color: isWithinLimit ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: isWithinLimit ? AppColors.buttonColors : Colors.grey,
                    size: 35,
                  ),
                  onPressed: () {
                    if (!isWithinLimit) {
                      _showCalorieWarning(context);
                    } else {
                      _showMealDetailsBottomSheet(
                        context,
                        widget.food,
                        widget.food.name,
                        'serving size : ${widget.food.servingInfo.size} ${widget.food.servingInfo.unit}',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCalorieWarning(BuildContext context) {
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
                BlocBuilder<ProgressBarBloc, ProgressBarState>(
                  builder: (context, state) {
                    if (state is ProgressBarLoaded) {
                      final remainingCalories = state.data.dailyCalorieGoal -
                          state.data.totalCaloriesConsumed;
                      return Text(
                        'This food (${widget.food.nutritionFacts.calories.toStringAsFixed(1)} Cal) exceeds your remaining calorie limit (${remainingCalories.toStringAsFixed(1)} Cal) for today.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
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
    BuildContext context,
    CommonFoodModel food,
    String name,
    String description,
  ) {
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CommonFoodConsumeBottomSheet(
                isHistoryScreen: false,
                servingSize: food.servingInfo.size,
                productId: food.id,
                userId: userId,
                calories: food.nutritionFacts.calories,
                mealName: name,
                servingInfo: description,
              ),
            ),
          );
        },
      );
    }
  }
}
