import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class CalorieSummaryWidget extends StatelessWidget {
  final double consumedCalories;  // Rename for clarity
  final double dailyCalorieGoal;  // Rename for clarity
  final int itemCount;
  final VoidCallback onViewOrderPressed;
  final Color backgroundColor;
  final Color buttonColor;
  final Color primaryColor;

  const CalorieSummaryWidget({
    super.key,
    required this.consumedCalories,   // Renamed parameter
    required this.dailyCalorieGoal,   // Renamed parameter
    required this.itemCount,
    required this.onViewOrderPressed,
    this.backgroundColor = Colors.black,
    this.buttonColor = AppColors.buttonColors,
    this.primaryColor = AppColors.primaryColor,
  });

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
    final double progress = (consumedCalories / dailyCalorieGoal).clamp(0.0, 1.0);
    final progressColor = _getProgressColor(progress);
    final remainingCalories = (dailyCalorieGoal - consumedCalories).round();

    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Calorie Progress',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        '${consumedCalories.toInt()}',
                        style: TextStyle(color: _getProgressColor(progress)),
                      ),
                      Text(
                        ' / ${dailyCalorieGoal.round()} cal',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.blueGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 10,
                ),
              ),
              // Add remaining calories display
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Remaining:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                   Text(
                    ' $remainingCalories cal',
                    style: TextStyle(
                      color: _getProgressColor(progress),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Order Summary Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total calories',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${consumedCalories.toInt()}cal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: onViewOrderPressed,
                child: Text(
                  'View order list ($itemCount items) >',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}