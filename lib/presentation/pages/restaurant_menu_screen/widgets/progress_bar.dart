import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';

class CalorieSummaryWidget extends StatelessWidget {
  final int itemCount;
  final VoidCallback onViewOrderPressed;
  final Color backgroundColor;
  final Color buttonColor;
  final Color primaryColor;
  final double cartCalories;

  const CalorieSummaryWidget({
    super.key,
    required this.itemCount,
    required this.onViewOrderPressed,
    required this.cartCalories,
    this.backgroundColor = Colors.black,
    this.buttonColor = AppColors.buttonColors,
    this.primaryColor = AppColors.primaryColor,
  });

  Color _getProgressColor(double progress) {
    if (progress <= 0.5) return Colors.green;
    if (progress <= 0.75) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBarBloc, ProgressBarState>(
      builder: (context, progressState) {
        if (progressState is ProgressBarLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (progressState is ProgressBarError) {
          return Center(child: Text(progressState.message));
        }

        if (progressState is ProgressBarLoaded) {
          final totalConsumedCalories =
              progressState.data.totalCaloriesConsumed + cartCalories;
          final dailyCalorieGoal = progressState.data.dailyCalorieGoal;
          final progress =
              (totalConsumedCalories / dailyCalorieGoal).clamp(0.0, 1.0);
          final currentRemaining = dailyCalorieGoal - totalConsumedCalories;

          return Container(
            padding: const EdgeInsets.all(16),
            color: backgroundColor,
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
                        AnimatedSlideFade(
                          child: Row(
                            children: [
                              Text(
                                '${totalConsumedCalories.toInt()}',
                                style: TextStyle(
                                  color: _getProgressColor(progress),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' / ${dailyCalorieGoal.round()} cal',
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedProgressBar(
                      value: progress,
                      color: _getProgressColor(progress),
                    ),
                    const SizedBox(height: 8),
                    AnimatedSlideFade(
                      child: Row(
                        children: [
                          const Text(
                            'Remaining:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' ${currentRemaining.round()} cal',
                            style: TextStyle(
                              color: _getProgressColor(progress),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                        AnimatedSlideFade(
                          child: Text(
                            '${totalConsumedCalories.toInt()}cal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedOrderButton(
                      itemCount: itemCount,
                      onPressed: onViewOrderPressed,
                      buttonColor: buttonColor,
                      primaryColor: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0, end: value),
      builder: (context, animatedValue, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: animatedValue,
            backgroundColor: Colors.blueGrey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        );
      },
    );
  }
}

class AnimatedSlideFade extends StatelessWidget {
  final Widget child;

  const AnimatedSlideFade({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(child.toString()),
        child: child,
      ),
    );
  }
}

class AnimatedOrderButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color primaryColor;

  const AnimatedOrderButton({
    super.key,
    required this.itemCount,
    required this.onPressed,
    required this.buttonColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: onPressed,
        child: AnimatedSlideFade(
          child: Text(
            'View cart ($itemCount items) >',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
