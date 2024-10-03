import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/otp_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/phone_number.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_newuser_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/userr_info_one.dart';

class EmailAuthScreen extends StatefulWidget {
  final bool isSignUp;

  const EmailAuthScreen({Key? key, this.isSignUp = false}) : super(key: key);

  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  late bool _isSignUp;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUp;
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

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
              mainHeading: _isSignUp ? "Create Account" : "Welcome back,",
              subHeading: _isSignUp ? "Let's get started" : "Glad You're here",
            ),
            SizedBox(height: size.height * (_isSignUp ? 0.04 : 0.07)),
            const CustomTextFormField(
              hintText: "Enter your Email id",
            ),
            const SizedBox(height: 20),
            const CustomTextFormField(
              isPassword: true,
              hintText: "Enter your Password",
            ),
            if (_isSignUp) ...[
              const SizedBox(height: 20),
              const CustomTextFormField(
                isPassword: true,
                hintText: "Re-enter your Password",
              ),
            ],
            const Spacer(),
            CustomButton(
              data: _isSignUp ? "Agree & SignUp" : "Agree & Login",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => 
                    _isSignUp ? const OtpScreen() : const UserInfoScreenOne()
                  ),
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
                      iconPath: 'assets/icons/call.png',
                      label: 'Phone',
                      size: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomNewUserText(
              text: _isSignUp ? "Already User? " : "New user? ",
              buttonText: _isSignUp ? "Login Account" : "Create an account",
              onCreateAccountTap: _toggleMode,
            ),
          ],
        ),
      ),
    );
  }
}