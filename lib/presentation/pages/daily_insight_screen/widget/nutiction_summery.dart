import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/daily_insight_screen/daily_food_response.dart';


class NutritionSummary extends StatelessWidget {
  final String dateTime;
  final ConsumedFood consumedFood;
  final DailySummary dailySummary;

  const NutritionSummary({
    super.key,
    required this.consumedFood,
    required this.dateTime,
    required this.dailySummary,
  });

  // Helper method to extract numeric value from nutrition facts
  double _getNutrientValue(dynamic nutrient) {
    if (nutrient == null) return 0.0;
    if (nutrient is NutrientInfo) {
      return nutrient.value;
    }
    if (nutrient is num) {
      return nutrient.toDouble();
    }
    if (nutrient is Map<String, dynamic>) {
      return (nutrient['value'] ?? 0.0).toDouble();
    }
    return 0.0;
  }

  // Calculate nutrition totals for a list of foods
  void calculateTotalNutrition(
      List<FoodItem> foods, Map<String, double> totals) {
    for (var food in foods) {
      totals['protein'] = (totals['protein'] ?? 0) +
          _getNutrientValue(food.nutritionFacts.protein);

      double carbValue =
          _getNutrientValue(food.nutritionFacts.totalCarbohydrates);
      if (carbValue == 0) {
        carbValue = _getNutrientValue(food.nutritionFacts.totalCarbohydrate);
      }
      if (carbValue == 0) {
        carbValue = _getNutrientValue(food.nutritionFacts.carbs);
      }
      totals['carbs'] = (totals['carbs'] ?? 0) + carbValue;

      double fatValue = _getNutrientValue(food.nutritionFacts.totalFat);
      if (fatValue == 0) {
        fatValue = _getNutrientValue(food.nutritionFacts.fat);
      }
      totals['fat'] = (totals['fat'] ?? 0) + fatValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and calculate responsive values
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate responsive dimensions
    final double containerPadding = _getResponsiveValue(
      context: context,
      extraSmall: 8.0,
      small: 10.0,
      medium: 12.0,
      large: 14.0,
    );

    final double spacingHeight = _getResponsiveValue(
      context: context,
      extraSmall: 12.0,
      small: 14.0,
      medium: 16.0,
      large: 18.0,
    );

    // Calculate font sizes
    final double titleFontSize = _getResponsiveValue(
      context: context,
      extraSmall: 10.0,
      small: 10.0,
      medium: 12.0,
      large: 14.0,
    );

    final double valueFontSize = _getResponsiveValue(
      context: context,
      extraSmall: 10.0,
      small: 11.0,
      medium: 12.0,
      large: 14.0,
    );

    // Initialize totals map
    Map<String, double> nutritionTotals = {
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };

    // Calculate totals for each meal
    calculateTotalNutrition(consumedFood.breakfast.foods, nutritionTotals);
    calculateTotalNutrition(consumedFood.lunch.foods, nutritionTotals);
    calculateTotalNutrition(consumedFood.dinner.foods, nutritionTotals);
    calculateTotalNutrition(consumedFood.snacks.foods, nutritionTotals);

    // final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return LayoutBuilder(builder: (context, constraints) {
      final containerWidth = constraints.maxWidth;
      final progressContainerWidth =
          (containerWidth - (containerPadding * 2) - 30) / 4;

      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: screenSize.width * 0.005,
        ),
        padding: EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Progress indicators row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProgressContainer(
                    'Calorie',
                    dailySummary.totalCalories,
                    dailySummary.dailyGoal,
                    AppColors.buttonColors,
                    'kcal',
                    progressContainerWidth,
                    titleFontSize,
                    valueFontSize,
                  ),
                  SizedBox(width: 8),
                  _buildProgressContainer(
                    'Protein',
                    nutritionTotals['protein']!,
                    150,
                    Colors.blue,
                    'g',
                    progressContainerWidth,
                    titleFontSize,
                    valueFontSize,
                  ),
                  SizedBox(width: 8),
                  _buildProgressContainer(
                    'Carbs',
                    nutritionTotals['carbs']!,
                    300,
                    Colors.orange,
                    'g',
                    progressContainerWidth,
                    titleFontSize,
                    valueFontSize,
                  ),
                  SizedBox(width: 8),
                  _buildProgressContainer(
                    'Fat',
                    nutritionTotals['fat']!,
                    65,
                    Colors.yellow,
                    'g',
                    progressContainerWidth,
                    titleFontSize,
                    valueFontSize,
                  ),
                ],
              ),
            ),
            SizedBox(height: spacingHeight),
            // Summary Information
            Container(
              padding: EdgeInsets.all(containerPadding),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    Icons.flag,
                    'Daily Target',
                    '${dailySummary.dailyGoal.toStringAsFixed(0)} cal',
                    titleFontSize,
                    valueFontSize,
                  ),
                  SizedBox(height: spacingHeight / 2),
                  _buildSummaryRow(
                    Icons.restaurant,
                    'Total Now',
                    '${dailySummary.totalCalories.toStringAsFixed(0)} cal',
                    titleFontSize,
                    valueFontSize,
                  ),
                  SizedBox(height: spacingHeight / 2),
                  _buildSummaryRow(
                    Icons.balance,
                    'Remaining',
                    '${dailySummary.remaining.toStringAsFixed(0)} cal',
                    titleFontSize,
                    valueFontSize,
                  ),
                  SizedBox(height: spacingHeight / 2),
                  _buildSummaryRow(
                    Icons.calendar_month,
                    'Date',
                    dateTime,
                    titleFontSize,
                    valueFontSize,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  double _getResponsiveValue({
    required BuildContext context,
    required double extraSmall,
    required double small,
    required double medium,
    required double large,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 320) return extraSmall;
    if (screenWidth < 375) return small;
    if (screenWidth < 414) return medium;
    return large;
  }

  Widget _buildProgressContainer(
    String label,
    double value,
    double target,
    Color color,
    String unit,
    double containerWidth,
    double titleFontSize,
    double valueFontSize,
  ) {
    return Container(
      width: containerWidth,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: valueFontSize - 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    IconData icon,
    String label,
    String value,
    double titleFontSize,
    double valueFontSize,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.buttonColors,
          size: titleFontSize + 4,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: titleFontSize,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
