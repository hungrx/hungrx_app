import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_event.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return BlocConsumer<OtpAuthBloc, OtpAuthState>(
      listener: (context, state) {
        if (state is OtpVerifySuccess) {
          context.pushReplacementNamed(RouteNames.userInfoOne);
        } else if (state is OtpVerifyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              body: GradientContainer(
                top: size.height * 0.09,
                left: size.height * 0.04,
                right: size.height * 0.04,
                bottom: size.height * 0.04,
                child: Form(
                  key: _formKey,
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
                      Text(
                        "Enter the OTP recived on ${widget.phoneNumber}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.fontColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Pinput(
                        length: 4,
                        controller: _otpController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: AppColors.buttonColors),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          if (value.length != 4) {
                            return 'OTP must be 4 digits';
                          }
                          return null;
                        },
                        onCompleted: (pin) {
                          print("enter:$pin");
                        },
                      ),
                      const Spacer(),
                      CustomButton(
                        data: "Verify",
                        onPressed: state is OtpVerifyLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<OtpAuthBloc>().add(
                                        VerifyOtpEvent(widget.phoneNumber,
                                            _otpController.text),
                                      );
                                }
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
                                iconPath: 'assets/icons/facebook.png',
                                label: 'Facebook',
                                size: 60,
                              ),
                              const SizedBox(width: 20),
                              SocialLoginBotton(
                                iconPath: 'assets/icons/mail.png',
                                label: 'Email',
                                size: 30,
                                onPressed: () {
                                  context.pushNamed(RouteNames.login);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            if (state is OtpVerifyLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
