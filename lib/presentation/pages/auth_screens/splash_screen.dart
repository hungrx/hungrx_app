import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'dart:async';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/data/repositories/auth_screen/onboarding_service.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_state.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_event.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_state.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_event.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_bloc.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_event.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_state.dart';
import 'package:hungrx_app/presentation/no_internet_screen/no_internet_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _authService.initialize();
    final userId = await _authService.getUserId();
    if (userId != null) {
      await _authService.checkProfileCompletion(userId);

      await _updateUserTimezone(userId);
    }
    _checkConnectivityAndNavigate();
  }

  Future<void> _updateUserTimezone(String userId) async {
    // ignore: unnecessary_null_comparison
    if (mounted && userId != null) {
      context.read<TimezoneBloc>().add(UpdateUserTimezone(userId));
    }
  }

  Future<void> _checkConnectivityAndNavigate() async {
    context.read<ConnectivityBloc>().add(CheckConnectivity());
  }

  Future<void> _checkSubscriptionStatus(String userId) async {
    if (mounted) {
      context
          .read<CheckStatusSubscriptionBloc>()
          .add(CheckSubscription(userId));
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final bool isLoggedIn = await _authService.isLoggedIn();

    final bool hasSeenOnboarding = await _onboardingService.hasSeenOnboarding();

    String route = '/phoneNumber';

    if (!hasSeenOnboarding) {
      route = '/onboarding';
    } else if (isLoggedIn) {
      try {
        final userId = await _authService.getUserId();

        if (userId != null) {
          // Check profile completion
          final bool? isProfileComplete =
              await _authService.checkProfileCompletion(userId);

          await _updateUserTimezone(userId);

          context.read<SubscriptionBloc>().add(UpdateSubscriptionInfo());
          await Future.delayed(const Duration(seconds: 1));
          // Check subscription status using BLoC
          await _checkSubscriptionStatus(userId);

          if (isProfileComplete == null) {
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text(
                      'Unable to verify your profile status. Please check your connection and try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<ConnectivityBloc>()
                            .add(CheckConnectivity());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return;
          }

          // Try to fetch home data
          try {
            final homeData = await _authService.fetchHomeData();
            if (homeData != null && mounted) {
              context.read<HomeBloc>().add(InitializeHomeData(homeData));
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to fetch home data'),
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }

          // Update streaks
          if (mounted) {
            context.read<StreakBloc>().add(FetchStreakData());
          }

          // Determine route based on profile completion and subscription status
          if (isProfileComplete) {
            // Check subscription state from BLoC
            final subscriptionState =
                context.read<CheckStatusSubscriptionBloc>().state;

            if (subscriptionState is CheckSubscriptionActive) {
              route = '/home';
              // print(
              //     "subscriptin stauts................... ${subscriptionState is CheckSubscriptionActive}");
            } else {
              route = '/subscriptionScreen';
            }
          } else {
            route = '/user-info-one';
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error checking profile status. Please try again.'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'There was an error checking your profile. Would you like to try again?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    GoRouter.of(context).go('/phoneNumber');
                  },
                  child: const Text('Login Again'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _checkConnectivityAndNavigate();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        route = '/phoneNumber';
      }
    }

    if (mounted) {
      GoRouter.of(context).go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityConnected) {
              _navigateToNextScreen();
            }
          },
        ),
        BlocListener<TimezoneBloc, TimezoneState>(
          listener: (context, state) {
            if (state is TimezoneUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update timezone: ${state.error}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        BlocListener<CheckStatusSubscriptionBloc, CheckStatusSubscriptionState>(
          listener: (context, state) {
            if (state is CheckSubscriptionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Subscription check failed: ${state.error}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
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
            backgroundColor: AppColors.buttonColors,
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/images/logos.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 35), // Adjust as needed
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.primaryColor,
                    size: 35,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
