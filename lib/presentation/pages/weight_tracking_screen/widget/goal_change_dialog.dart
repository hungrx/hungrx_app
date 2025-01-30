import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_event.dart';

class GoalChangeDialog extends StatelessWidget {
  final bool isGaining;
  final double newWeight;
  final Function() onGoalChangePressed;

  const GoalChangeDialog({
    super.key,
    required this.isGaining,
    required this.newWeight,
    required this.onGoalChangePressed,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isGaining,
    required double newWeight,
    required Function() onGoalChangePressed,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => GoalChangeDialog(
        isGaining: isGaining,
        newWeight: newWeight,
        onGoalChangePressed: onGoalChangePressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.buttonColors.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonColors.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button at the top
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white70,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            
            // Icon indicating direction
            Icon(
              isGaining ? Icons.trending_up : Icons.trending_down,
              color: isGaining ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              'Weight ${isGaining ? 'Gain' : 'Loss'} Detected',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Content
            Text(
              isGaining
                ? 'Your weight has increased significantly. Would you like to:'
                : 'Your weight has decreased significantly. Would you like to:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            
            // Update Weight Button
            ElevatedButton(
              onPressed: () {
                context.read<WeightUpdateBloc>().add(
                  UpdateWeightRequested(newWeight),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColors,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Update Weight Only',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
                //  onPressed: () async {
                //   Navigator.of(context).pop();
                //   await Future.delayed(const Duration(milliseconds: 100));
                //   context.go('/home');
                // },
            // Change Goal Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onGoalChangePressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: AppColors.buttonColors,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Change Goal to ${isGaining ? 'Lose' : 'Gain'} Weight',
                style: const TextStyle(
                  color: AppColors.buttonColors,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}