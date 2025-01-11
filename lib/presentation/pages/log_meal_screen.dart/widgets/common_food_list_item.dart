import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/meals_detail_sheet.dart';

class CommonFoodListItem extends StatelessWidget {
  final CommonFoodModel food;

  const CommonFoodListItem({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'serving size : ${food.servingInfo.size} ${food.servingInfo.unit}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            Text(
              'Category : ${food.category.main}',
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
                  context,
                  food,
                  food.name,
                  'serving size : ${food.servingInfo.size} ${food.servingInfo.unit}',
                );
              },
            ),
          ],
        ),
      ),
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
                    userId: state.userId ??
                        "", // You'll need to get this from your user bloc
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
  }
}

// Update the CommonFoodList to import and use CommonFoodListItem
class CommonFoodList extends StatelessWidget {
  final List<CommonFoodModel> foods;

  const CommonFoodList({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return CommonFoodListItem(food: food);
      },
    );
  }
}
