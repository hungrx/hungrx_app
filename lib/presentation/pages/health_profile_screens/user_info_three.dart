import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/goal_selection_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';

class UserInfoScreenThree extends StatefulWidget {
  const UserInfoScreenThree({super.key});

  @override
  UserInfoScreenThreeState createState() => UserInfoScreenThreeState();
}

class UserInfoScreenThreeState extends State<UserInfoScreenThree> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  double mealsPerDay = 1;
  bool isMetric = false; // New state variable for unit selection

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
                          currentStep: 3,
                          totalSteps: 6,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Help Us Calculate Your\nTDEE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Add the unit toggle button here
                        UnitToggle(
                          isMetric: isMetric,
                          onToggle: (value) {
                            setState(() {
                              isMetric = value;
                              heightController.clear(); // Clear height when switching units
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "What's your Height?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        // Modify height input based on selected unit
                        if (isMetric)
                          CustomTextFormField(
                            controller: heightController,
                            hintText: 'Enter Your Height (cm)',
                            keyboardType: TextInputType.number,
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: heightController,
                                  hintText: 'Feet',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: CustomTextFormField(
                                  hintText: 'Inches',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                        const Text(
                          "What's your Weight?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: weightController,
                          hintText: isMetric ? 'Enter Your Weight (kg)' : 'Enter Your Weight (lbs)',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "How many times do you typically\neat in a day?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Slider(
                          value: mealsPerDay,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: AppColors.buttonColors,
                          inactiveColor: Colors.grey[800],
                          label: mealsPerDay.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              mealsPerDay = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [1, 2, 3, 4, 5]
                              .map((e) => Text(
                                    e.toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 100), // Extra space at the bottom
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: NavigationButtons(
                  onNextPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GoalSelectionScreen()),
                    );
                  },
                ),
              ),
            ],
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
            alignment: isMetric ? Alignment.centerRight : Alignment.centerLeft,
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
                  onTap: () => onToggle(false),
                  child: Center(
                    child: Text(
                      'Ft/In',
                      style: TextStyle(
                        color: !isMetric ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  child: Center(
                    child: Text(
                      'Cm',
                      style: TextStyle(
                        color: isMetric ? Colors.black : Colors.white,
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