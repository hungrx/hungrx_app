import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/tdee_confirm_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/detail_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

class DailyExpenditureScreen extends StatefulWidget {
  const DailyExpenditureScreen({super.key});

  @override
  DailyExpenditureScreenState createState() => DailyExpenditureScreenState();
}

class DailyExpenditureScreenState extends State<DailyExpenditureScreen> {
  String? selectedActivity;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: GradientContainer(
        top: size.height * 0.06,
        left: size.height * 0.01,
        right: size.height * 0.01,
        bottom: size.height * 0.01,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SteppedProgressBar(
                  currentStep: 6,
                  totalSteps: 6,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Help us calculate your TDEE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "What's your Activity Level?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildActivityButton(
                            'Sedentary', 'Little or no exercise'),
                        const SizedBox(height: 10),
                        _buildActivityButton(
                            'Light', 'Exercise 1-3 times/week'),
                        const SizedBox(height: 10),
                        _buildActivityButton(
                            'Moderate', 'Exercise 4-5 times/week'),
                        const SizedBox(height: 10),
                        _buildActivityButton('Active',
                            'Daily exercise or intense exercise 3-4 times/week'),
                        const SizedBox(height: 10),
                        _buildActivityButton(
                            'Very Active', 'Intense exercise 6-7 times/week'),
                        const SizedBox(height: 10),
                        _buildActivityButton('Extra Active',
                            'Very intense exercise daily, or physical job'),
                      ],
                    ),
                  ),
                ),
                NavigationButtons(
                  onNextPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TDEEResultScreen(
                          onClose: () {
                            // Navigate to your Home Screen here
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const DetailScreen()),
                            );
                          },
                          results: const {
                            'tdee': 2500.0,
                            'bmr': 1800.0,
                            'bmi': 22.5,
                            'height': 175,
                            'weight': 70,
                            'calorie_goal': 2000,
                            'calories_to_lose': 500,
                            'days_to_goal': 60,
                            'goal_pace': 0.5,
                          },
                        ),
                      ),
                    );

                    // if (selectedActivity != null) {
                    //   // Navigate to the next screen or process the selected activity
                    //   print('Selected Activity: $selectedActivity');
                    //   // TODO: Add navigation to next screen
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Please select an activity level')),
                    //   );
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityButton(String activity, String description) {
    bool isSelected = selectedActivity == activity;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedActivity = activity;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.buttonColors : Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity,
              style: TextStyle(
                color: isSelected ? AppColors.buttonColors : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
