import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:hungrx_app/data/Models/home_screen_model.dart';

class AnimatedCalorieDisplay extends StatefulWidget {
  final HomeData data;
  final Stream<double>? calorieUpdateStream; // Stream for real-time updates
  
  const AnimatedCalorieDisplay({
    super.key,
    required this.data,
    this.calorieUpdateStream,
  });

  @override
  State<AnimatedCalorieDisplay> createState() => _AnimatedCalorieDisplayState();
}

class _AnimatedCalorieDisplayState extends State<AnimatedCalorieDisplay> {
  late double _displayValue;
  StreamSubscription<double>? _subscription;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.data.caloriesToReachGoal.toDouble();
    
    // Listen to calorie updates if stream is provided
    if (widget.calorieUpdateStream != null) {
      _subscription = widget.calorieUpdateStream!.listen((newValue) {
        setState(() {
          _displayValue = newValue;
        });
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedCalorieDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate when data changes from parent
    if (oldWidget.data.caloriesToReachGoal != widget.data.caloriesToReachGoal) {
      setState(() {
        _displayValue = widget.data.caloriesToReachGoal.toDouble();
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedFlipCounter(
          value: _displayValue,
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
  }
}