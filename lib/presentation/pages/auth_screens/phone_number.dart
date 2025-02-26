import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_state.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_event.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_state.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_bloc.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_event.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/pivacy_policy_botton.dart';

class PhoneNumberScreen extends StatefulWidget {
  final bool isSignUp;

  const PhoneNumberScreen({super.key, this.isSignUp = false});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  bool _termsAccepted = false;

  bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.height < 600;

  bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.height >= 600 &&
      MediaQuery.of(context).size.height < 800;

  double getResponsivePadding(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) return 8.0;
    if (screenHeight < 800) return 16.0;
    return 24.0;
  }

  double getResponsiveSpacing(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) return screenHeight * 0.02;
    if (screenHeight < 800) return screenHeight * 0.03;
    return screenHeight * 0.04;
  }

  double getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return baseSize * (screenWidth / 375.0); // 375 is baseline width
  }

  void _hideLoadingOverlay(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  void _handleAppleSignIn(BuildContext context) {
    if (!_termsAccepted) {
      _showTermsAcceptanceError(context);
      return;
    }
    context.read<AppleAuthBloc>().add(AppleSignInRequested());
  }

  void _showTermsAcceptanceError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please accept the Terms & Conditions to continue'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleAppleAuthError(BuildContext context, String error) {
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
            context.read<AppleAuthBloc>().add(AppleSignInRequested());
          },
        ),
      ),
    );
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

  Future<void> _handleAuthSuccess(BuildContext context, String? userId) async {
    if (userId != null) {
      try {
        final authService = AuthService();
        final isProfileComplete =
            await authService.checkProfileCompletion(userId);

        if (mounted) {
          context.read<TimezoneBloc>().add(UpdateUserTimezone(userId));
        }

        if (!mounted) return;

        if (isProfileComplete == true) {
          GoRouter.of(context).go('/home');
        } else if (isProfileComplete == false) {
          GoRouter.of(context).go('/user-info-one');
        } else {
          _showConnectionError(context);
        }
      } catch (e) {
        if (!mounted) return;
        _showProfileCheckError(context, e.toString());
      }
    } else {
      if (!mounted) return;
      _handleAuthError(context, 'Failed to get user ID');
    }
  }

  void _showConnectionError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Error'),
        content: const Text(
            'Unable to verify your profile status. Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showProfileCheckError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error checking profile status. Please try again.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _handleAuthError(context, 'Error during profile check: $error');
  }

  void _handleAuthError(BuildContext context, String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = getResponsivePadding(context);
    final spacing = getResponsiveSpacing(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AppleAuthBloc, AppleAuthState>(
          listener: (context, state) async {
            if (!mounted) return;

            if (state is AppleAuthSuccess) {
              try {
                final authService = AuthService();
                final userId = await authService.getUserId();
                if (!mounted) return;

                await _handleAuthSuccess(context, userId);
              } catch (e) {
                if (!mounted) return;
                _handleAppleAuthError(
                    context, 'Failed to process sign in: ${e.toString()}');
              }
            } else if (state is AppleAuthCancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sign in cancelled'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is AppleAuthFailure) {
              _handleAppleAuthError(context, state.error);
            }
          },
        ),
        BlocListener<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) async {
            if (!mounted) return;

            if (state is GoogleAuthSuccess) {
              final authService = AuthService();
              final userId = await authService.getUserId();
              if (!mounted) return;
              await _handleAuthSuccess(context, userId);
            } else if (state is GoogleAuthCancelled) {
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
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GradientContainer(
                top: size.height * 0.02,
                left: padding,
                right: padding,
                bottom: padding,
                child: Column(
                  children: [
                    // Improved Header with Animation
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: 1.0,
                      child: HeaderText(
                        mainHeading:
                            widget.isSignUp ? "Create Account" : "Welcome",
                        subHeading: widget.isSignUp
                            ? "Let's get started"
                            : "Glad You're here",
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
        
                    // Improved Social Login Container
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.06,
                              vertical: constraints.maxHeight * 0.04,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(
                                  isSmallScreen(context) ? 20 : 30),
                              border: Border.all(
                                color: AppColors.buttonColors.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(
                                  context: context,
                                  iconPath: 'assets/icons/google.png',
                                  label: 'Continue with Google',
                                  onPressed: () {
                                    if (!_termsAccepted) {
                                      _showTermsAcceptanceError(context);
                                      return;
                                    }
                                    context
                                        .read<GoogleAuthBloc>()
                                        .add(GoogleSignInRequested());
                                  },
                                ),
                                SizedBox(height: spacing),
                                _buildSocialButton(
                                  context: context,
                                  iconPath: 'assets/icons/apple.png',
                                  label: 'Continue with Apple',
                                  onPressed: () => _handleAppleSignIn(context),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        
                    SizedBox(height: spacing),
        
                    // Improved Terms and Conditions Container
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: isSmallScreen(context) ? 8.0 : 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(
                            isSmallScreen(context) ? 15 : 20),
                        border: Border.all(
                          color: AppColors.buttonColors.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: isSmallScreen(context) ? 0.8 : 0.9,
                            child: Checkbox(
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
                                        : Colors.grey.withOpacity(0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: ClickableTermsAndPolicyText(
                                policyUrl:
                                    "https://www.hungrx.com/privacy-policy.html",
                                termsUrl:
                                    "https://www.hungrx.com/terms-and-conditions.html",
                                textStyle: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: getResponsiveFontSize(context, 13),
                                  height: 1.3,
                                ),
                                linkStyle: TextStyle(
                                  color: Colors.blue[300],
                                  fontSize: getResponsiveFontSize(context, 13),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
              if (context.watch<GoogleAuthBloc>().state is GoogleAuthLoading ||
                  context.watch<AppleAuthBloc>().state is AppleAuthLoading)
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
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
  }) {
    final isSmall = isSmallScreen(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmall ? 20 : 30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(isSmall ? 20 : 30),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: isSmall ? 12 : 16,
              horizontal: isSmall ? 16 : 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isSmall ? 20 : 30),
              border: Border.all(
                color: AppColors.buttonColors.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  height: isSmall ? 20 : 24,
                  width: isSmall ? 20 : 24,
                ),
                SizedBox(width: isSmall ? 8 : 12),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveFontSize(context, isSmall ? 14 : 16),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
