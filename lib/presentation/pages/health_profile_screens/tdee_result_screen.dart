import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/premium_container.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/dashboard_screen.dart';

class TDEEResultScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Map<String, dynamic> results;

  const TDEEResultScreen({
    super.key,
    required this.onClose,
    required this.results,
  });

  @override
  TDEEResultScreenState createState() => TDEEResultScreenState();
}

class TDEEResultScreenState extends State<TDEEResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GradientContainer(
        top: size.height * 0.00,
        left: size.height * 0.01,
        right: size.height * 0.01,
        bottom: size.height * 0.01,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardScreen()),
                          );
                        }),
                  ),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
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
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
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
                  const SizedBox(height: 24),
                  _buildResultCard('BMR (Basal Metabolic Rate)',
                      '${widget.results['bmr']?.toStringAsFixed(0) ?? 'N/A'} kcal'),
                  _buildResultCard('BMI',
                      widget.results['bmi']?.toStringAsFixed(1) ?? 'N/A'),
                  _buildResultCard('TDEE (Total Daily Energy Expenditure)',
                      '${widget.results['tdee']?.toStringAsFixed(0) ?? 'N/A'} kcal'),
                  _buildResultCard('Height',
                      '${widget.results['height']?.toString() ?? 'N/A'} cm'),
                  _buildResultCard('Weight',
                      '${widget.results['weight']?.toString() ?? 'N/A'} kg'),
                  _buildResultCard('Daily Calorie Goal',
                      '${widget.results['calorie_goal']?.toStringAsFixed(0) ?? 'N/A'} kcal'),
                  _buildResultCard('Calories to Lose',
                      '${widget.results['calories_to_lose']?.toStringAsFixed(0) ?? 'N/A'} kcal'),
                  _buildResultCard('Days to Reach Goal',
                      '${widget.results['days_to_goal']?.toString() ?? 'N/A'} days'),
                  _buildResultCard('Goal Pace',
                      '${widget.results['goal_pace']?.toStringAsFixed(1) ?? 'N/A'} kg/week'),
                  const SizedBox(
                    height: 50,
                  ),
                  FadeTransition(
                      opacity: _opacityAnimation,
                      child: const PremiumContainer()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8), // Match the Card's border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white, // Change text color to white
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Change text color to white
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
