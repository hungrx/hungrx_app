import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/user_info_two.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/custom_button.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/header_text.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

class UserInfoScreenOne extends StatefulWidget {
  const UserInfoScreenOne({super.key});

  @override
  State<UserInfoScreenOne> createState() => _UserInfoScreenOneState();
}

class _UserInfoScreenOneState extends State<UserInfoScreenOne> {
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
                  currentStep: 1,
                  totalSteps: 6,
                ),
                const SizedBox(height: 40),
                const HeaderTextDataScreen(
                  data: 'Hey there! \nTell Us About Yourself',
                ),
                const SizedBox(height: 30),
                const Text(
                  "What's your Name ?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 10),
                const CustomTextFormField(hintText: 'Enter Your Name'),
                const SizedBox(height: 20),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CustomNextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserInfoScreenTwo()),
                      );
                    },
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
