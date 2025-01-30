import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:hungrx_app/data/Models/profile_setting_screen/tdee_result_model.dart';
import 'package:hungrx_app/routes/route_names.dart';

class CelebrationDialogManager {
  final ConfettiController confettiController;
  final AnimationController dialogAnimationController;

  CelebrationDialogManager({
    required this.confettiController,
    required this.dialogAnimationController,
  });

  void showCelebrationDialog(BuildContext context, TDEEResultModel tdeeResult) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    // Reset controllers
    confettiController.stop();
    dialogAnimationController.reset();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Confetti Widget positioned at the center-top
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirection: pi / 2, // Shoots straight up
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
            ),
            // Dialog content
            WillPopScope(
              onWillPop: () async => false,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: dialogAnimationController,
                  curve: Curves.easeOutBack,
                ),
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: Container(
                    width: size.width * 0.8,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: isSmallScreen ? 40 : 50,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.green.shade300,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            "Profile Complete!",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        Text(
                          "Your TDEE calculation is ready.",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey[300],
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Redirecting...",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Play animations
    confettiController.play();
    dialogAnimationController.forward();

    // Navigate after delay with error handling
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        context.pushReplacementNamed(RouteNames.tdeeResults, extra: tdeeResult);
      }
    }).catchError((error) {
      debugPrint('Navigation error: $error');
    });
  }
}
