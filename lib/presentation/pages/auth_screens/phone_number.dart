import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_bloc.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_event.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_state.dart';
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


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => CountryCodeBloc(),
      child: BlocConsumer<OtpAuthBloc, OtpAuthState>(
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
                                    textStyle:
                                        const TextStyle(color: Colors.white),
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
                        CustomButton(
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
                                    final phoneNumber =
                                        countryCode + _phoneController.text;
                                    print(phoneNumber);
                                    context
                                        .read<OtpAuthBloc>()
                                        .add(SendOtpEvent(phoneNumber));
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
              if (state is OtpSendLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // You can adjust this regex pattern based on your specific requirements
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }
}
