import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/email_login.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/otp_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_newuser_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
              mainHeading: "Create your Account",
              subHeading: "",
            ),
            SizedBox(
              height: size.height * 0.04,
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
            const SizedBox(
              height: 20,
            ),
            const CustomTextFormField(
              isPassword: true,
              hintText: "Re-enter your Password",
            ),
            const Spacer(),
            // Terms of Service text

            // Agree & Log In button
            CustomButton(
              data: "Agree & SignUp",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpScreen()),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const ClickableTermsAndPolicyText(
              policyUrl: "https://www.hungrx.com/",
              termsUrl: "https://www.hungrx.com/",
            ),

            // Social login options
            const Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialLoginBotton(
                      iconPath: 'assets/icons/google.png',
                      label: 'Google',
                      size: 25,
                    ),
                    SizedBox(width: 20),
                    SocialLoginBotton(
                      iconPath: 'assets/icons/apple.png',
                      label: 'Apple',
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    SocialLoginBotton(
                      iconPath: 'assets/icons/call.png',
                      label: 'Email',
                      size: 25,
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
              text: "Already User? ",
              buttonText: "Login Account",
              onCreateAccountTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmailLoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
