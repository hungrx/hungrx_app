import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/tdee_result_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/detail_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive
}

class DailyActivityScreen extends StatefulWidget {
  const DailyActivityScreen({super.key});

  @override
  DailyActivityScreenState createState() => DailyActivityScreenState();
}

class DailyActivityScreenState extends State<DailyActivityScreen> {
  ActivityLevel? selectedActivity;

  final Map<ActivityLevel, String> activityDescriptions = {
    ActivityLevel.sedentary: "Little to no exercise, desk job",
    ActivityLevel.lightlyActive: "Light exercise 1-3 days/week",
    ActivityLevel.moderatelyActive: "Moderate exercise 3-5 days/week",
    ActivityLevel.veryActive: "Hard exercise 6-7 days/week",
    ActivityLevel.extraActive: "Very hard exercise & physical job or 2x training",
  };

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
                      children: ActivityLevel.values.map((activity) {
                        return Column(
                          children: [
                            _buildActivityButton(activity),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                NavigationButtons(
                  onNextPressed: () {
                    if (selectedActivity != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => TDEEResultScreen(
                            onClose: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const DetailScreen()),
                              );
                            },
                            results:  {
                              'tdee': 2500.0,
                              'bmr': 1800.0,
                              'bmi': 22.5,
                              'height': 175,
                              'weight': 70,
                              'calorie_goal': 2000,
                              'calories_to_lose': 500,
                              'days_to_goal': 60,
                              'goal_pace': 0.5,
                              'activity_level': selectedActivity,  // Add this line
                            },
                          ),
                        ),
                      );
                    } else {
                      // Show an error message if no activity is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an activity level')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityButton(ActivityLevel activity) {
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
              activity.toString().split('.').last,
              style: TextStyle(
                color: isSelected ? AppColors.buttonColors : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activityDescriptions[activity]!,
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