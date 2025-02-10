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
    HomeDataNotifier.caloriesNotifier.value = widget.initialData.caloriesToReachGoal.toDouble();
  }

  // Get dynamic font size based on screen width
  double _getResponsiveFontSize(BuildContext context, {
    double smallScreenSize = 50,
    double mediumScreenSize = 65,
    double largeScreenSize = 80,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 360) {
      return smallScreenSize;
    } else if (width < 600) {
      return mediumScreenSize;
    } else {
      return largeScreenSize;
    }
  }

  // Get dynamic padding based on screen size
  EdgeInsets _getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 360) {
      return const EdgeInsets.only(bottom: 15, left: 3);
    } else if (width < 600) {
      return const EdgeInsets.only(bottom: 18, left: 4);
    } else {
      return const EdgeInsets.only(bottom: 22, left: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive calculations
    // final screenWidth = MediaQuery.of(context).size.width;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<double>(
          valueListenable: HomeDataNotifier.caloriesNotifier,
          builder: (context, calories, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedFlipCounter(
                      curve: Curves.easeInOut,
                      hideLeadingZeroes: true,
                      value: calories,
                      wholeDigits: 6,
                      duration: const Duration(milliseconds: 3000),
                      textStyle: GoogleFonts.stickNoBills(
                        color: Colors.white,
                        fontSize: _getResponsiveFontSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: _getResponsivePadding(context),
                  child: Text(
                    'cal',
                    style: GoogleFonts.stickNoBills(
                      color: Colors.grey,
                      fontSize: _getResponsiveFontSize(context) * 0.25, // Make 'cal' text proportional to main number
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}