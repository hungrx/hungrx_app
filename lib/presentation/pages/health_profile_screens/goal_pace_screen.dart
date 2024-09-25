import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/dialy_expanditure_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/goal_selection_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

class GoalPaceScreen extends StatefulWidget {
  final WeightGoal goal;

  const GoalPaceScreen({super.key, required this.goal});

  @override
  GoalPaceScreenState createState() => GoalPaceScreenState();
}

class GoalPaceScreenState extends State<GoalPaceScreen> {
  double paceValue = 2.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
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
                  currentStep: 5,
                  totalSteps: 6,
                ),
                const SizedBox(height: 40),
                Text(
                  _getTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'This is the recommended pace, but you can adjust as needed.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    _getPaceText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'per week',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 40),
                Slider(
                  value: paceValue,
                  min: 1,
                  max: 3,
                  divisions: 2,
                  activeColor: AppColors.buttonColors,
                  inactiveColor: Colors.grey[800],
                  onChanged: (value) {
                    setState(() {
                      paceValue = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _getPaceLabels(),
                ),
                const Spacer(),
                NavigationButtons(
                  onNextPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  const DailyExpenditureScreen(),
                          ),
                        );
                    // Handle next button press
                    // print('Selected pace: ${_getPaceText()} per week');
                    // Navigate to the next screen or process the data
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.goal) {
      case WeightGoal.lose:
        return 'How fast do you want to\nlose weight?';
      case WeightGoal.gain:
        return 'How fast do you want to\ngain weight?';
      case WeightGoal.maintain:
        return 'Maintain your current\nweight';
    }
  }

  String _getPaceText() {
    if (widget.goal == WeightGoal.maintain) {
      return '0 Kg';
    }
    double pace = (paceValue - 1) * 0.25 + 0.25; // 0.25, 0.5, or 0.75 kg
    return '${pace.toStringAsFixed(2)} Kg';
  }

  List<Widget> _getPaceLabels() {
    if (widget.goal == WeightGoal.maintain) {
      return [const Text('Maintain', style: TextStyle(color: Colors.grey))];
    }
    return ['Mild', 'Moderate', 'Fast'].map((e) => Text(
      e,
      style: const TextStyle(color: Colors.grey),
    )).toList();
  }
}