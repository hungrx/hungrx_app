import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:hungrx_app/presentation/blocs/login_bloc/login_event.dart';
import 'package:hungrx_app/presentation/blocs/login_bloc/login_state.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_event.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_newuser_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/social_login_btn.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class EmailAuthScreen extends StatefulWidget {
  final bool isSignUp;

  const EmailAuthScreen({super.key, this.isSignUp = false});

  @override
  EmailAuthScreenState createState() => EmailAuthScreenState();
}

class EmailAuthScreenState extends State<EmailAuthScreen> {
  late bool _isSignUp;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();

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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateReenterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_isSignUp) {
        context.read<SignUpBloc>().add(SignUpSubmitted(
              email: _emailController.text,
              password: _passwordController.text,
              reenterPassword: _reenterPasswordController.text,
            ));
      } else {
        context.read<LoginBloc>().add(LoginSubmitted(
              email: _emailController.text,
              password: _passwordController.text,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up successful!')),
              );
              context.pushNamed(RouteNames.userInfoOne);
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!')),
              );
              context.pushNamed(RouteNames.home);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
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
                      mainHeading: _isSignUp ? "Create Account" : "Welcome back,",
                      subHeading: _isSignUp ? "Let's get started" : "Glad You're here",
                    ),
                    SizedBox(height: size.height * (_isSignUp ? 0.04 : 0.07)),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: "Enter your Email id",
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _passwordController,
                      isPassword: true,
                      hintText: "Enter your Password",
                      validator: _validatePassword,
                    ),
                    if (!_isSignUp) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.forgotPassword);
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    if (_isSignUp) ...[
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _reenterPasswordController,
                        isPassword: true,
                        hintText: "Re-enter your Password",
                        validator: _validateReenterPassword,
                      ),
                    ],
                    const Spacer(),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return CustomButton(
                          data: _isSignUp ? "Agree & SignUp" : "Agree & Login",
                          onPressed: state is LoginLoading ? null : _submitForm,
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
                              iconPath: 'assets/icons/facebook.png',
                              label: 'Facebook',
                              size: 60,
                            ),
                            const SizedBox(width: 20),
                            SocialLoginBotton(
                              iconPath: 'assets/icons/call.png',
                              label: 'Phone',
                              size: 25,
                              onPressed: () {
                                context.pushNamed(RouteNames.phoneNumber);
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
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return state is LoginLoading
                    ? Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}