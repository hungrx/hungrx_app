import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_bloc.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_event.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_state.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_state.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_event.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:hungrx_app/routes/route_names.dart';

class PhoneNumberScreen extends StatefulWidget {
  final bool isSignUp;

  const PhoneNumberScreen({super.key, this.isSignUp = false});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _termsAccepted = false;

  void _hideLoadingOverlay(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
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

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Remove any non-digit characters
    final cleanNumber = value.replaceAll(RegExp(r'\D'), '');

    // Check for valid US number length (10 digits)
    if (cleanNumber.length != 10) {
      return 'Please enter a valid 10-digit US phone number';
    }

    // Validate area code (first 3 digits)
    final areaCode = int.parse(cleanNumber.substring(0, 3));
    if (areaCode < 200 || // Area codes don't start with 0 or 1
        areaCode >= 1000 ||
        areaCode == 666 || // Restricted area code
        cleanNumber.substring(3, 6) == '555') {
      // 555 is reserved
      return 'Please enter a valid US area code';
    }

    return null;
  }

  Future<bool> _onWillPop() async {
    // Check if keyboard is visible
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    if (isKeyboardVisible) {
      // If keyboard is visible, close it
      FocusScope.of(context).unfocus();
      return false; // Prevents app from closing
    }

    // If Google Auth is loading, hide loading overlay
    if (context.read<GoogleAuthBloc>().state is GoogleAuthLoading) {
      _hideLoadingOverlay(context);
      return false;
    }

    // If keyboard is not visible and no loading state, allow app to close
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CountryCodeBloc(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OtpAuthBloc, OtpAuthState>(
            listener: (context, state) {
              if (state is OtpSendSuccess) {
                context.pushNamed(
                  RouteNames.otpVerify,
                  pathParameters: {
                    'phoneNumber': context
                            .read<CountryCodeBloc>()
                            .state
                            .selectedCountryCode +
                        _phoneController.text
                  },
                );
              } else if (state is OtpSendFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          BlocListener<GoogleAuthBloc, GoogleAuthState>(
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
          ),
        ],
        child: Builder(
          builder: (context) {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    GradientContainer(
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
                            HeaderText(
                              mainHeading: widget.isSignUp
                                  ? "Create Account"
                                  : "Welcome,",
                              subHeading: widget.isSignUp
                                  ? "Let's get started"
                                  : "Glad You're here",
                            ),
                            SizedBox(height: size.height * 0.07),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  BlocBuilder<CountryCodeBloc,
                                      CountryCodeState>(
                                    builder: (context, countryCodeState) {
                                      return CountryCodePicker(
                                        onChanged: (CountryCode countryCode) {
                                          context.read<CountryCodeBloc>().add(
                                                CountryCodeChanged(
                                                    countryCode.dialCode ??
                                                        '+1'),
                                              );
                                        },
                                        initialSelection: 'US',
                                        favorite: const ['+1', '+91'],
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                        padding: EdgeInsets.zero,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                      );
                                    },
                                  ),
                                  Container(
                                      height: 30,
                                      width: 1,
                                      color: Colors.grey[600]),
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      hintText: "Enter your phone number",
                                      validator: _validatePhoneNumber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            BlocBuilder<OtpAuthBloc, OtpAuthState>(
                              builder: (context, state) {
                                return CustomButton(
                                  data: widget.isSignUp
                                      ? "Agree & Sign Up"
                                      : "Agree & Login",
                                  onPressed: () {
                                    if (!_termsAccepted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'Please accept the Terms & Conditions to continue'),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    if (_formKey.currentState!.validate()) {
                                      final countryCode = context
                                          .read<CountryCodeBloc>()
                                          .state
                                          .selectedCountryCode;
                                      final phoneNumber =
                                          countryCode + _phoneController.text;
                                      context
                                          .read<OtpAuthBloc>()
                                          .add(SendOtpEvent(phoneNumber));
                                    }
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _termsAccepted = value ?? false;
                                    });
                                  },
                                  fillColor: MaterialStateProperty.resolveWith(
                                    (states) =>
                                        states.contains(MaterialState.selected)
                                            ? AppColors.buttonColors
                                            : Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    // Wrap with GestureDetector for better tap handling
                                    behavior: HitTestBehavior.opaque,
                                    child: ClickableTermsAndPolicyText(
                                      
                                      policyUrl:
                                          "https://www.hungrx.com/privacy-policy.html",
                                      termsUrl:
                                          "https://www.hungrx.com/terms-and-conditions.html",
                                      textStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12),
                                      linkStyle: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                          if (!_termsAccepted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Please accept the Terms & Conditions to continue'),
                                                backgroundColor: Colors.red,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin:
                                                    const EdgeInsets.all(16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                            return;
                                          }
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
                                          if (!_termsAccepted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Please accept the Terms & Conditions to continue'),
                                                backgroundColor: Colors.red,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin:
                                                    const EdgeInsets.all(16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          // context.read<GoogleAuthBloc>().add(GoogleSignInRequested());
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
                    // Loading overlays
                    if (context.watch<OtpAuthBloc>().state is OtpSendLoading ||
                        context.watch<GoogleAuthBloc>().state
                            is GoogleAuthLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.buttonColors,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
