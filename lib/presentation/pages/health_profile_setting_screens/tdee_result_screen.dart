import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/citation_ibutton.dart';
import 'package:hungrx_app/data/Models/profile_setting_screen/tdee_result_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/premium_container.dart';

class TDEEResultScreen extends StatefulWidget {
  final TDEEResultModel tdeeResult;

  const TDEEResultScreen({super.key, required this.tdeeResult});

  @override
  TDEEResultScreenState createState() => TDEEResultScreenState();
}

class TDEEResultScreenState extends State<TDEEResultScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
  }

  Future<bool> _onWillPop() async {
    if (_isNavigating) return false;

    _isNavigating = true;
    await _navigateToHome(context);
    return false;
  }

  Future<void> _navigateToHome(BuildContext context) async {
    try {
      final userId = await _authService.getUserId();

      if (!mounted) return;

      if (userId == null) {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/home');
        return;
      }

      final homeData = await _authService.fetchHomeData();

      if (!mounted) return;

      if (homeData != null) {
        // ignore: use_build_context_synchronously
        context.read<HomeBloc>().add(InitializeHomeData(homeData));
        // ignore: use_build_context_synchronously
        context.read<StreakBloc>().add(FetchStreakData());
      }

      // Using context.go instead of GoRouter.of(context).go() for more concise code
      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error navigating to home: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to home even if there's an error
      // ignore: use_build_context_synchronously
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GradientContainer(
          top: size.height * 0.00,
          left: size.height * 0.01,
          right: size.height * 0.01,
          bottom: size.height * 0.01,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 24),
                          _buildResults(widget.tdeeResult, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.buttonColors,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.buttonColors.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _opacityAnimation,
            child: const Text(
              'Your Results Are Ready!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonColors,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(TDEEResultModel result, BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Column(
        children: [
          // Motivational greeting based on goal
          _buildMotivationalGreeting(result.goal),
          const SizedBox(height: 10),
    Align(
            alignment: Alignment.centerLeft,  // Changed to align left
            child: InfoButton(
              metricType: 'all_metrics',
              compact: false,
              size: 24,
              color: AppColors.buttonColors,
            ),
          ),
          // Basic stats
          _buildResultCard('Goal', _formatGoal(result.goal)),
          _buildResultCard('Height', result.height),
          _buildResultCard('Weight', result.weight),
          _buildResultCard('BMI', result.bmi),
          _buildResultCard('BMR', result.bmr),
          _buildResultCard('TDEE', result.tdee),
          _buildResultCard('Daily Calorie Goal', result.dailyCaloriesGoal),
          _buildResultCard('Daily Water Intake', result.dailyWaterIntake),

          // Conditional fields based on goal
          if (result.goal.toLowerCase() != 'maintain weight') ...[
            _buildCaloriesToGoalCard(result),
            _buildResultCard('Days to Goal', result.daysToReachGoal),
            _buildResultCard('Goal Pace', result.goalPace),
          ],

          const SizedBox(height: 10),
          FadeTransition(
            opacity: _opacityAnimation,
            child: PremiumContainer(
              onpress: () => _navigateToHome(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalGreeting(String goal) {
    String greeting;
    String message;

    switch (goal.toLowerCase()) {
      case 'maintain weight':
        greeting = "Great Choice for Balance! 🌟";
        message =
            "Maintaining a healthy weight is key to long-term wellness. We'll help you stay on track!";
        break;
      case 'lose weight':
        greeting = "You're on Your Way! 💪";
        message =
            "Every step counts towards your goal. We're here to support your weight loss journey!";
        break;
      case 'gain weight':
        greeting = "Let's Build Together! 🎯";
        message =
            "Ready to help you gain strength and reach your target weight safely!";
        break;
      default:
        greeting = "Welcome to Your Journey! 🌱";
        message = "We're here to support you every step of the way!";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: AppColors.buttonColors.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.buttonColors.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            greeting,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(width: 20),
      
        ],
      ),
    );
  }

  String _formatGoal(String goal) {
    // Capitalize first letter of each word
    return goal.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Widget _buildCaloriesToGoalCard(TDEEResultModel result) {
    String title;
    switch (result.goal.toLowerCase()) {
      case 'lose weight':
        title = 'Calories to Burn';
        break;
      case 'gain weight':
        title = 'Calories to Consume';
        break;
      default:
        return const SizedBox
            .shrink(); // Return empty widget for maintain weight
    }

    return _buildResultCard(title, result.caloriesToReachGoal);
  }

  Widget _buildResultCard(String title, String value) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
