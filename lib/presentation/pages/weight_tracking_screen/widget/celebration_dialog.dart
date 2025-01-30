import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class CelebrationDialog extends StatefulWidget {
  final String currentWeight;
  final Function(BuildContext, bool) onDialogClosed;

  const CelebrationDialog({
    super.key,
    required this.currentWeight,
    required this.onDialogClosed,
  });

  static Future<void> show(
    BuildContext context, {
    required String currentWeight,
    required Function(BuildContext, bool) onDialogClosed,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CelebrationDialog(
        currentWeight: currentWeight,
        onDialogClosed: onDialogClosed,
      ),
    );
  }

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _dialogAnimationController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Start animations when dialog is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogAnimationController.forward();
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isSmallScreen = size.width < 375;

    return Stack(
      children: [
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _dialogAnimationController,
            curve: Curves.easeOutBack,
          ),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              width: size.width * 0.8,
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.buttonColors, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: AppColors.buttonColors,
                    size: isSmallScreen ? 40 : 50,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Congratulations!",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "You've reached your target weight!",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Would you like to set a new goal?",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onDialogClosed(context, false);
                        },
                        child: const Text('Not Now',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onDialogClosed(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColors,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('Set New Goal',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: pi / 2,
          maxBlastForce: 5,
          minBlastForce: 1,
          emissionFrequency: 0.05,
          numberOfParticles: 50,
          gravity: 0.1,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
        ),
      ],
    );
  }
}

// Usage example:
