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
                        const SizedBox(height: 30),
                        const Text(
                          "What's your Height?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: heightController,
                          hintText: 'Enter Your Height',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "What's your Weight?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: weightController,
                          hintText: 'Enter Your Weight',
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
                        const SizedBox(
                            height: 100), // Extra space at the bottom
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: NavigationButtons(
                  onNextPressed: () {
                    // if (heightController.text.isNotEmpty && weightController.text.isNotEmpty) {
                    //   print('Height: ${heightController.text}, Weight: ${weightController.text}, Meals per day: ${mealsPerDay.round()}');
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Please enter your height and weight')),
                    //   );
                    // }
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
