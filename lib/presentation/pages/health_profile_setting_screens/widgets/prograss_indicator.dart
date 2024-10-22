import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class SteppedProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  const SteppedProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor = AppColors.buttonColors,
    this.inactiveColor = Colors.grey,
    this.height = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        return Expanded(
          child: Container(
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}