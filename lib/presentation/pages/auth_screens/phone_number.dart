import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/email_auth_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/otp_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_newuser_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';

class PhoneNumberScreen extends StatelessWidget {
  final bool isSignUp;

  const PhoneNumberScreen({super.key, this.isSignUp = false});

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
            HeaderText(
              mainHeading: isSignUp ? "Create Account" : "Welcome back,",
              subHeading: isSignUp ? "Let's get started" : "Glad You're here",
            ),
            SizedBox(height: size.height * 0.07),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Row(
                      children: [
                        Text("🇺🇸", style: TextStyle(fontSize: 24)),
                        SizedBox(width: 5),
                        Text("+1", style: TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                  Container(height: 30, width: 1, color: Colors.grey[600]),
                  const Expanded(
                    child: CustomTextFormField(
                      keyboardType: TextInputType.phone,
                      hintText: "Enter your phone number",
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              data: isSignUp ? "Agree & Sign Up" : "Agree & Login",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            const ClickableTermsAndPolicyText(
              policyUrl: "https://www.hungrx.com/",
              termsUrl: "https://www.hungrx.com/",
            ),
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
                      iconPath: 'assets/icons/mail.png',
                      label: 'Email',
                      size: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EmailAuthScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomNewUserText(
              text: isSignUp ? "Already have an account? " : "New user? ",
              buttonText: isSignUp ? "Sign In" : "Create an account",
              onCreateAccountTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PhoneNumberScreen(isSignUp: !isSignUp)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}