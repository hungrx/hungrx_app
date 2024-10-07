import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/user_info_three.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/header_text.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

class UserInfoScreenTwo extends StatefulWidget {
  const UserInfoScreenTwo({super.key});

  @override
  UserInfoScreenTwoState createState() => UserInfoScreenTwoState();
}

class UserInfoScreenTwoState extends State<UserInfoScreenTwo> {
  String selectedGender = 'Male';
  TextEditingController ageController = TextEditingController();

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
                  currentStep: 2,
                  totalSteps: 6,
                ),
                const SizedBox(height: 40),
                const HeaderTextDataScreen(
                  data: 'Tell Us About Yourself',
                ),
                const SizedBox(height: 30),
                const Text(
                  "Please select which sex we should use to\ncalculate your calorie needs.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 20),
                _buildGenderSelector(),
                const SizedBox(height: 50),
                const Text(
                  "What's your Age?",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                const SizedBox(height: 10),
                const CustomTextFormField(
                    keyboardType: TextInputType.phone,
                    hintText: 'Enter Your Age'),
                    const SizedBox(height: 10),
                     const Text(
                  "Your age determines how much you should consume(age in year)",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Spacer(),
                NavigationButtons(
                  onNextPressed: () {
                    // if (ageController.text.isNotEmpty) {
                    //   // Process the data and navigate to the next screen
                    //   // print(
                    //   //     'Gender: $selectedGender, Age: ${ageController.text}');
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Please enter your age')),
                    //   );
                    // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserInfoScreenThree()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors, width: 1),
      ),
      child: Row(
        children: [
          _buildGenderOption('Male',Icons.male),
          _buildGenderOption('Female',Icons.female),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender,IconData? icon) {
    bool isSelected = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.buttonColors : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,size: 30,color: isSelected ? Colors.black : Colors.white,),
              const SizedBox(width: 5,),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
