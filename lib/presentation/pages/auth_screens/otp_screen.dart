import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/create_account.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/email_login.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_newuser_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/userr_info_one.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.buttonColors),
        borderRadius: BorderRadius.circular(8),
      ),
    );

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
              height: size.height * 0.06,
            ),
            const Text(
              "Enter OTP received on +91839494949",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.fontColor,
              ),
            ),
            const SizedBox(height: 20),
            Pinput(
              length: 4,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: AppColors.buttonColors),
                ),
              ),
              // onCompleted: (pin) => print(pin),
            ),
            const Spacer(),

            // Agree & Log In button
            CustomButton(
              data: "Verify",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreenOne()),
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
                      iconPath: 'assets/icons/mail.png',
                      label: 'Email',
                      size: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailLoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
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
