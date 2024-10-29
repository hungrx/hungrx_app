import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'dart:async';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/data/repositories/onboarding_service.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_event.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_state.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/no_internet_screen/no_internet_screen.dart';

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
    _checkConnectivityAndNavigate();
    // _navigateToNextScreen();
  
  }
  Future<void> _checkConnectivityAndNavigate() async {
    // Initial connectivity check
    context.read<ConnectivityBloc>().add(CheckConnectivity());
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;
// auth service .is loggedin method is check the use logged in or not
    final bool isLoggedIn = await _authService.isLoggedIn();
    final bool isProfileComplete =
        await _authService.isProfileComplete() ?? true;
    final bool hasSeenOnboarding = await _onboardingService.hasSeenOnboarding();

    if (isLoggedIn) {
      try {
        final homeData = await _authService.fetchHomeData();
        final userId = await _authService.getUserId();
        if (homeData != null && mounted) {
          print(userId);
          // Initialize HomeBloc with fetched data
          context.read<HomeBloc>().add(InitializeHomeData(homeData));
        }

        if (userId != null && mounted) {
          context.read<StreakBloc>().add(FetchStreakData(userId));
        }
      } catch (e) {
        print('Error fetching initial home data: $e');
      }
    }
    if (!mounted) return;

    String route = '/login';
    if (isLoggedIn) {
      route = isProfileComplete ? '/home' : '/user-info-one';
    } else if (!hasSeenOnboarding) {
      route = '/onboarding';
    }

    GoRouter.of(context).go(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityConnected) {
          _navigateToNextScreen();
        }
      },
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          if (state is ConnectivityDisconnected) {
            return NoInternetScreen(
              onRetry: () {
                context.read<ConnectivityBloc>().add(CheckConnectivity());
              },
            );
          }

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
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.buttonColors),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
