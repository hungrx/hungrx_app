import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/presentation/controller/home_data_notifier.dart';

class AnimatedCalorieDisplay extends StatefulWidget {
  final HomeData initialData;
  const AnimatedCalorieDisplay({
    super.key,
    required this.initialData,
  });

  @override
  State<AnimatedCalorieDisplay> createState() => _AnimatedCalorieDisplayState();
}

class _AnimatedCalorieDisplayState extends State<AnimatedCalorieDisplay> {
  @override
  void initState() {
    super.initState();
    // Initialize the notifier with initial data
    HomeDataNotifier.caloriesNotifier.value = widget.initialData.caloriesToReachGoal.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: HomeDataNotifier.caloriesNotifier,
      builder: (context, calories, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedFlipCounter(
              value: calories,
              wholeDigits: 6,
              duration: const Duration(milliseconds: 500),
              textStyle: GoogleFonts.stickNoBills(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 22, left: 5),
              child: Text(
                'cal',
                style: GoogleFonts.stickNoBills(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}