import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/create_account.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/phone_number.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_newuser_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:hungrx_app/presentation/pages/home_screen/home_screen.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GradientContainer(
        top: size.height * 0.09,
        left: size.height * 0.04,
        right: size.height * 0.04,
        bottom: size.height * 0.04,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderText(
              mainHeading: "Welcome back,",
              subHeading: "Glad You're here",
            ),
            SizedBox(
              height: size.height * 0.07,
            ),
            const CustomTextFormField(
              hintText: "Enter your Email id",
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextFormField(
              isPassword: true,
              hintText: "Enter your Password",
            ),
            const Spacer(),

            // Agree & Log In button
            CustomButton(
              data: "Agree & Login",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // Terms of Service text
            const ClickableTermsAndPolicyText(
              policyUrl: "https://www.hungrx.com/",
              termsUrl: "https://www.hungrx.com/",
            ),

            // Social login options
            Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SocialLoginBotton(
                      iconPath: 'assets/icons/google.png',
                      label: 'Google',
                      size: 25,
                    ),
                    const SizedBox(width: 20),
                    const SocialLoginBotton(
                      iconPath: 'assets/icons/apple.png',
                      label: 'Apple',
                      size: 30,
                    ),
                    const SizedBox(width: 20),
                    SocialLoginBotton(
                      iconPath: 'assets/icons/call.png',
                      label: 'Phone',
                      size: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PhoneNumberScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            // New user text
            CustomNewUserText(
              text: "New user? ",
              buttonText: "Create an account",
              onCreateAccountTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
