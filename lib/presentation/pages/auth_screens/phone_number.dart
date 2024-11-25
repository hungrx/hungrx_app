import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
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

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.buttonColors,
            ),
          ),
        ),
      ),
    );
  }

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
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
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
                    'phoneNumber':
                        context.read<CountryCodeBloc>().state.selectedCountryCode +
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
            listener: (context, state) {
              if (state is GoogleAuthLoading) {
                _showLoadingOverlay(context);
              } else if (state is GoogleAuthSuccess) {
                _hideLoadingOverlay(context);
                context.pushNamed(RouteNames.userInfoOne);
              } else if (state is GoogleAuthCancelled) {
                _hideLoadingOverlay(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign in cancelled'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is GoogleAuthFailure) {
                _handleGoogleAuthError(context, state.error);
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                if (context.read<GoogleAuthBloc>().state is GoogleAuthLoading) {
                  _hideLoadingOverlay(context);
                  return false;
                }
                return true;
              },
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
                                  : "Welcome back,",
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
                                  BlocBuilder<CountryCodeBloc, CountryCodeState>(
                                    builder: (context, countryCodeState) {
                                      return CountryCodePicker(
                                        onChanged: (CountryCode countryCode) {
                                          context.read<CountryCodeBloc>().add(
                                                CountryCodeChanged(
                                                    countryCode.dialCode ?? '+1'),
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
                                  onPressed: state is OtpSendLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            final countryCode = context
                                                .read<CountryCodeBloc>()
                                                .state
                                                .selectedCountryCode;
                                            final phoneNumber = countryCode +
                                                _phoneController.text;
                                            context
                                                .read<OtpAuthBloc>()
                                                .add(SendOtpEvent(phoneNumber));
                                          }
                                        },
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
                                    SocialLoginBotton(
                                      iconPath: 'assets/icons/google.png',
                                      label: 'Google',
                                      size: 25,
                                      onPressed: () {
                                        context
                                            .read<GoogleAuthBloc>()
                                            .add(GoogleSignInRequested());
                                      },
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
                    // Loading overlays
                    if (context.watch<OtpAuthBloc>().state is OtpSendLoading ||
                        context.watch<GoogleAuthBloc>().state is GoogleAuthLoading)
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