import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/profile_setting_screen/tdee_result_model.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/routes/route_names.dart';

class DailyActivityScreen extends StatefulWidget {
  const DailyActivityScreen({super.key});

  @override
  DailyActivityScreenState createState() => DailyActivityScreenState();
}

class DailyActivityScreenState extends State<DailyActivityScreen>
    with TickerProviderStateMixin {
  final Map<ActivityLevel, String> activityDescriptions = const {
    ActivityLevel.sedentary: "Little to no exercise, desk job",
    ActivityLevel.lightlyActive: "Light exercise 1-3 days/week",
    ActivityLevel.moderatelyActive: "Moderate exercise 3-5 days/week",
    ActivityLevel.veryActive: "Hard exercise 6-7 days/week",
    ActivityLevel.extraActive: "Very hard exercise & physical job or 2x training",
  };

  late ConfettiController _confettiController;
  late AnimationController _dialogAnimationController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _dialogAnimationController.dispose();
    super.dispose();
  }

  void _showCelebrationDialog(BuildContext context, TDEEResultModel tdeeResult) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: _dialogAnimationController,
            curve: Curves.easeOutBack,
          ),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              width: size.width * 0.8,
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: isSmallScreen ? 40 : 50,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "All Set!",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Your profile is complete.",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    _confettiController.play();
    _dialogAnimationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      context.pushNamed(RouteNames.tdeeResults, extra: tdeeResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<UserProfileFormBloc, UserProfileFormState>(
            listener: (context, state) {
              if (state.isSuccess && state.tdeeResult != null) {
                _showCelebrationDialog(context, state.tdeeResult!);
              }
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
            builder: (context, state) {
              return GradientContainer(
                top: size.height * 0.06,
                left: size.height * 0.01,
                right: size.height * 0.01,
                bottom: size.height * 0.01,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SteppedProgressBar(
                          currentStep: 6,
                          totalSteps: 6,
                        ),
                        
                        SizedBox(height: size.height * 0.04),
                        
                        Text(
                          'Help us calculate your TDEE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: size.height * 0.03),
                        
                        Text(
                          "What's your Activity Level?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        
                        SizedBox(height: size.height * 0.02),
                        
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: ActivityLevel.values.map((activity) {
                                return Column(
                                  children: [
                                    _buildActivityButton(
                                      context,
                                      activity,
                                      state.activityLevel,
                                      size,
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        
                        NavigationButtons(
                          buttonText: "Finish",
                          onNextPressed: state.isLoading
                              ? (){}
                              : () {
                                  if (state.activityLevel != null) {
                                    context
                                        .read<UserProfileFormBloc>()
                                        .add(SubmitForm());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please select an activity level'),
                                      ),
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
          // Loading overlay
          BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.buttonColors,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Calculating your TDEE...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityButton(
    BuildContext context,
    ActivityLevel activity,
    ActivityLevel? selectedActivity,
    Size size,
  ) {
    final isSmallScreen = size.width < 360;
    final isSelected = selectedActivity == activity;

    return BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state.isLoading
              ? null
              : () {
                  context.read<UserProfileFormBloc>()
                      .add(ActivityLevelChanged(activity));
                },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.018,
              horizontal: size.width * 0.05,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.buttonColors : Colors.grey[700]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.toString().split('.').last,
                  style: TextStyle(
                    color: isSelected ? AppColors.buttonColors : Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.004),
                Text(
                  activityDescriptions[activity]!,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: isSmallScreen ? 11 : 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}