import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/facebook_auth/facebook_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/facebook_auth/facebook_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/facebook_auth/facebook_auth_state.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_state.dart';
import 'package:hungrx_app/presentation/blocs/email_login_bloc/login_bloc.dart';
import 'package:hungrx_app/presentation/blocs/email_login_bloc/login_event.dart';
import 'package:hungrx_app/presentation/blocs/email_login_bloc/login_state.dart';
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Success',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Account creation successful',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColors,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(RouteNames.login);
                },
                child: const Text(
                  'Signin Now',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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

  void _handleAuthError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              _showSuccessDialog();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up successful!')),
              );
              // context.pushNamed(RouteNames.login);
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        // BlocListener<LoginBloc, LoginState>(
        //   listener: (context, state) {
        //     if (state is LoginSuccess) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('Login successful!')),
        //       );
        //       context.pushNamed(RouteNames.home);
        //     } else if (state is LoginFailure) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text(state.error)),
        //       );
        //     }
        //   },
        // ),

        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (!mounted) return; // Initial mounted check

            if (state is LoginLoading) {
              _showLoadingOverlay(context);
            } else if (state is LoginSuccess) {
              _hideLoadingOverlay(context);

              // Store context in local variable for safety
              final currentContext = context;

              if (!mounted) return;

              final authService = AuthService();
              try {
                final isProfileComplete =
                    await authService.checkProfileCompletion(state.token);
                if (!mounted) return;

                if (isProfileComplete) {
                  // Existing user - navigate to home
                  if (mounted) {
                    GoRouter.of(currentContext).go('/home');
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Welcome!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  // New user - navigate to profile completion
                  if (mounted) {
                    GoRouter.of(currentContext).go('/user-info-one');
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete your profile'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
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
            } else if (state is LoginFailure) {
              _hideLoadingOverlay(context);
              if (mounted) {
                _handleAuthError(context, state.error);
              }
            }
          },
        ),

// In EmailAuthScreen
        BlocListener<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) async {
            if (!mounted) return; // Add mounted check at the start

            if (state is GoogleAuthLoading) {
              _showLoadingOverlay(context);
            } else if (state is GoogleAuthSuccess) {
              _hideLoadingOverlay(context);

              // Store context in local variable
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

                  if (isProfileComplete) {
                    // Existing user - navigate to home
                    if (mounted) {
                      GoRouter.of(currentContext).go('/home');
                    }
                  } else {
                    // New user - navigate to user info screen
                    if (mounted) {
                      GoRouter.of(currentContext).go('/user-info-one');
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
              _hideLoadingOverlay(context);
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
        BlocListener<FacebookAuthBloc, FacebookAuthState>(
          listener: (context, state) {
            if (state is FacebookAuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facebook Sign-In successful!')),
              );
              context.pushNamed(RouteNames.home);
            } else if (state is FacebookAuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          // Handle back button press while authentication is in progress
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
                        mainHeading:
                            _isSignUp ? "Create Account" : "Welcome back,",
                        subHeading: _isSignUp
                            ? "Let's get started"
                            : "Glad You're here",
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
                            data:
                                _isSignUp ? "Agree & SignUp" : "Agree & Login",
                            onPressed:
                                state is LoginLoading ? null : _submitForm,
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
                                  BlocProvider.of<GoogleAuthBloc>(context)
                                      .add(GoogleSignInRequested());
                                },
                              ),
                              const SizedBox(width: 20),
                              SocialLoginBotton(
                                iconPath: 'assets/icons/apple.png',
                                label: 'Apple',
                                size: 30,
                                onPressed: () {
                                  context
                                      .read<FacebookAuthBloc>()
                                      .add(FacebookSignInRequested());
                                },
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
                        buttonText:
                            _isSignUp ? "Login Account" : "Create an account",
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
                            child: CircularProgressIndicator(
                              color: AppColors.buttonColors,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  if (state is SignUpLoading) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonColors,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
