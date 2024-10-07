import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'dart:async';
import 'package:hungrx_app/data/repositories/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    
    if (!mounted) return;

    final bool isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      context.go('/dashboard');
    } else {
      context.go('/onboarding');
    }
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