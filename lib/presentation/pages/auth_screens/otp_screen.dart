import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_state.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_event.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? appSignature;
  Timer? _timer;
  int _remainingTime = 30; // 30 seconds cooldown
  bool _canResend = false;

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code ?? '';
      if (code?.length == 4) {
        context.read<OtpAuthBloc>().add(
              VerifyOtpEvent(widget.phoneNumber, code!),
            );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
    _startTimer();
  }

  void _startTimer() {
    if (!mounted) return;

    setState(() {
      _remainingTime = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleResendOtp() {
    if (_canResend) {
      context.read<OtpAuthBloc>().add(SendOtpEvent(widget.phoneNumber));
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
    cancel();
  }

  void _handleGoogleAuthError(BuildContext context, String error) {
    _hideLoadingOverlay(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            context.read<GoogleAuthBloc>().add(GoogleSignInRequested());
          },
        ),
      ),
    );
  }

  void _hideLoadingOverlay(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final defaultPinTheme = PinTheme(
    //   width: 50,
    //   height: 50,
    //   textStyle: const TextStyle(
    //     fontSize: 22,
    //     color: Colors.white,
    //   ),
    //   decoration: BoxDecoration(
    //     border: Border.all(color: AppColors.buttonColors),
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    // );

    Size size = MediaQuery.of(context).size;
    return BlocConsumer<OtpAuthBloc, OtpAuthState>(
      listener: (context, state) async {
        if (!mounted) return;

        if (state is OtpVerifySuccess) {
          final currentContext = context;

          if (!mounted) return;

          final authService = AuthService();
          final userId = await authService.getUserId();

          if (!mounted) return;

          if (userId != null) {
            try {
              final isProfileComplete =
                  await authService.checkProfileCompletion(userId);
              if (!mounted) return;

              // Handle different cases
              if (isProfileComplete == true) {
                // Confirmed existing user - navigate to home
                if (mounted) {
                  GoRouter.of(currentContext).go('/home');
                }
              } else if (isProfileComplete == false) {
                // Confirmed new user - navigate to user info screen
                if (mounted) {
                  GoRouter.of(currentContext).go('/user-info-one');
                }
              } else {
                // Server error case (isProfileComplete is null)
                if (mounted) {
                  // Show error dialog
                  showDialog(
                    context: currentContext,
                    builder: (context) => AlertDialog(
                      title: const Text('Connection Error'),
                      content: const Text(
                          'Unable to verify your profile status. Please check your internet connection and try again.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Optionally, you could add a retry mechanism here
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Error checking profile status. Please try again.'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          }
        } else if (state is OtpVerifyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Otp verification failed Try again",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return BlocListener<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) async {
            if (!mounted) return;

            if (state is GoogleAuthSuccess) {
              final currentContext = context;

              if (!mounted) return;

              final authService = AuthService();
              final userId = await authService.getUserId();

              if (!mounted) return;

              if (userId != null) {
                try {
                  final isProfileComplete =
                      await authService.checkProfileCompletion(userId);
                  if (!mounted) return;

                  if (isProfileComplete == true) {
                    // Existing user - navigate to home
                    if (mounted) {
                      GoRouter.of(currentContext).go('/home');
                    }
                  } else if (isProfileComplete == false) {
                    // New user - navigate to user info screen
                    if (mounted) {
                      GoRouter.of(currentContext).go('/user-info-one');
                    }
                  } else {
                    // Server error case (isProfileComplete is null)
                    if (mounted) {
                      // Show error dialog
                      showDialog(
                        context: currentContext,
                        builder: (context) => AlertDialog(
                          title: const Text('Connection Error'),
                          content: const Text(
                              'Unable to verify your profile status. Please check your internet connection and try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Optionally, you could add a retry mechanism here
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Error checking profile status. Please try again.'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    _handleGoogleAuthError(
                        currentContext, 'Error during profile check: $e');
                  }
                }
              } else {
                if (mounted) {
                  _handleGoogleAuthError(
                      currentContext, 'Failed to get user ID');
                }
              }
            } else if (state is GoogleAuthCancelled) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign in cancelled'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } else if (state is GoogleAuthFailure) {
              if (mounted) {
                _handleGoogleAuthError(context, state.error);
              }
            }
          },
          child: Stack(
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
                          mainHeading: "Welcome,",
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
                        PinFieldAutoFill(
                          codeLength: 4,
                          controller: _otpController,
                          decoration: BoxLooseDecoration(
                            strokeColorBuilder: PinListenColorBuilder(
                              AppColors.buttonColors,
                              AppColors.buttonColors,
                            ),
                            bgColorBuilder:
                                const FixedColorBuilder(Colors.transparent),
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          currentCode: _otpController.text,
                          onCodeSubmitted: (code) {
                            context.read<OtpAuthBloc>().add(
                                  VerifyOtpEvent(widget.phoneNumber, code),
                                );
                          },
                          onCodeChanged: (code) {
                            if (code?.length == 4) {
                              context.read<OtpAuthBloc>().add(
                                    VerifyOtpEvent(widget.phoneNumber, code!),
                                  );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _canResend
                                  ? "Didn't receive OTP?"
                                  : "Resend OTP in $_remainingTime seconds",
                              style: TextStyle(
                                color: AppColors.fontColor,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: _canResend ? _handleResendOtp : null,
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(
                                  color: _canResend
                                      ? AppColors.buttonColors
                                      : AppColors.fontColor.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                          policyUrl:
                              "https://www.hungrx.com/privacy-policy.html",
                          termsUrl:
                              "https://www.hungrx.com/terms-and-conditions.html",
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SocialLoginBotton(
                                    iconPath: 'assets/icons/google.png',
                                    label: 'Google',
                                    size: 25,
                                    onPressed: () {
                                      context
                                          .read<GoogleAuthBloc>()
                                          .add(GoogleSignInRequested());
                                    },
                                    style: SocialButtonStyle.capsule,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SocialLoginBotton(
                                    iconPath: 'assets/icons/apple.png',
                                    label: 'Apple',
                                    size: 25,
                                    onPressed: () {
                                      // Implement Apple sign in
                                    },
                                    style: SocialButtonStyle.capsule,
                                  ),
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
          ),
        );
      },
    );
  }
}
