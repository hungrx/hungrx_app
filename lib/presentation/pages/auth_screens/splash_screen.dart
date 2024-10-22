import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'dart:async';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/data/repositories/onboarding_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;
// auth service .is loggedin method is check the use logged in or not
    final bool isLoggedIn = await _authService.isLoggedIn();
    final bool hasSeenOnboarding = await _onboardingService.hasSeenOnboarding();

    if (!mounted) return;

    String route = '/login';
    if (isLoggedIn) {
      route = '/user-info-one';
    } else if (!hasSeenOnboarding) {
      route = '/onboarding';
    }

    GoRouter.of(context).go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/companylogo.jpeg',
              width: 350,
              height: 350,
            ),
            const Text(
              'hungrX',
              style: TextStyle(
                fontSize: 79,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}