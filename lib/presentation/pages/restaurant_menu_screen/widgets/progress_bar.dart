import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class CalorieSummaryWidget extends StatefulWidget {
  final double consumedCalories;
  final double dailyCalorieGoal;
  final int itemCount;
  final VoidCallback onViewOrderPressed;
  final Color backgroundColor;
  final Color buttonColor;
  final Color primaryColor;

  const CalorieSummaryWidget({
    super.key,
    required this.consumedCalories,
    required this.dailyCalorieGoal,
    required this.itemCount,
    required this.onViewOrderPressed,
    this.backgroundColor = Colors.black,
    this.buttonColor = AppColors.buttonColors,
    this.primaryColor = AppColors.primaryColor,
  });

  @override
  State<CalorieSummaryWidget> createState() => _CalorieSummaryWidgetState();
}

class _CalorieSummaryWidgetState extends State<CalorieSummaryWidget> {
  double? _previousRemaining;

  @override
  void initState() {
    super.initState();
    _previousRemaining = widget.dailyCalorieGoal - widget.consumedCalories;
  }

  @override
  void didUpdateWidget(covariant CalorieSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _previousRemaining only when consumedCalories changes
    if (widget.consumedCalories != oldWidget.consumedCalories) {
      _previousRemaining = widget.dailyCalorieGoal - oldWidget.consumedCalories;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.5) return Colors.green;
    if (progress <= 0.75) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final currentRemaining = widget.dailyCalorieGoal - widget.consumedCalories;

    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 0, end: widget.consumedCalories),
                    builder: (context, value, child) {
                      final progress =
                          (value / widget.dailyCalorieGoal).clamp(0.0, 1.0);
                      return Row(
                        children: [
                          Text(
                            '${value.toInt()}',
                            style:
                                TextStyle(color: _getProgressColor(progress)),
                          ),
                          Text(
                            ' / ${widget.dailyCalorieGoal.round()} cal',
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(
                  begin: (_previousRemaining ?? widget.dailyCalorieGoal) /
                      widget.dailyCalorieGoal,
                  end: (widget.consumedCalories / widget.dailyCalorieGoal)
                      .clamp(0.0, 1.0),
                ),
                builder: (context, value, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.blueGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(value),
                      ),
                      minHeight: 10,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(
                  begin: _previousRemaining ?? widget.dailyCalorieGoal,
                  end: currentRemaining,
                ),
                builder: (context, value, child) {
                  final progress =
                      (widget.consumedCalories / widget.dailyCalorieGoal)
                          .clamp(0.0, 1.0);
                  return Row(
                    children: [
                      const Text(
                        'Remaining:',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        ' ${value.round()} cal',
                        style: TextStyle(
                          color: _getProgressColor(progress),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 0, end: widget.consumedCalories),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toInt()}cal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: widget.onViewOrderPressed,
                child: Text(
                  'View order list (${widget.itemCount} items) >',
                  style: TextStyle(color: widget.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

