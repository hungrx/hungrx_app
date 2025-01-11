import 'package:flutter/material.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/common_food_list_item.dart';

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
