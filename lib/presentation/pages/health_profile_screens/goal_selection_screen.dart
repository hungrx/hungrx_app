import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/goal_pace_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

enum WeightGoal { lose, maintain, gain }

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  GoalSelectionScreenState createState() => GoalSelectionScreenState();
}

class GoalSelectionScreenState extends State<GoalSelectionScreen> {
  WeightGoal? selectedGoal;
  TextEditingController weightController = TextEditingController();
  bool isMetric = true; // New state variable for unit selection

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SteppedProgressBar(
                          currentStep: 4,
                          totalSteps: 6,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Every step towards your goal is progress.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "What's your Goal ?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        _buildGoalButton(WeightGoal.lose, 'Lose Weight'),
                        const SizedBox(height: 10),
                        _buildGoalButton(WeightGoal.maintain, 'Maintain Weight'),
                        const SizedBox(height: 10),
                        _buildGoalButton(WeightGoal.gain, 'Gain Weight'),
                        const SizedBox(height: 20),
                        if (selectedGoal == WeightGoal.lose || selectedGoal == WeightGoal.gain)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "What's is your target weight?",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Based on your BMI of 27.7',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                               Text(
                                'Your ideal weight range is 54-66 kg',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 10),
                              // Add the unit toggle button here
                              UnitToggle(
                                isMetric: isMetric,
                                onToggle: (value) {
                                  setState(() {
                                    isMetric = value;
                                    weightController.clear(); // Clear weight when switching units
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                keyboardType: TextInputType.number,
                                hintText: 'Input the goal weight (${isMetric ? 'kg' : 'lbs'})',
                                controller: weightController,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: NavigationButtons(
                  onNextPressed: () {
                    if (selectedGoal != null) {
                      if ((selectedGoal == WeightGoal.lose || selectedGoal == WeightGoal.gain) && weightController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter your goal weight')),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  GoalPaceScreen(goal: selectedGoal!,currentWeight: 50,goalWeight: 75,),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a goal')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalButton(WeightGoal goal, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = goal;
          if (goal == WeightGoal.maintain) {
            weightController.clear();
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selectedGoal == goal ? AppColors.buttonColors : Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selectedGoal == goal ? AppColors.buttonColors : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Add this new widget for the unit toggle button
class UnitToggle extends StatelessWidget {
  final bool isMetric;
  final ValueChanged<bool> onToggle;

  const UnitToggle({
    super.key,
    required this.isMetric,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: isMetric ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.buttonColors,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  child: Center(
                    child: Text(
                      'kg',
                      style: TextStyle(
                        color: isMetric ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  child: Center(
                    child: Text(
                      'lbs',
                      style: TextStyle(
                        color: !isMetric ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}