import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
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

class DailyActivityScreenState extends State<DailyActivityScreen> with TickerProviderStateMixin {
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

  void _showCelebrationDialog(BuildContext context) {
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 20),
                  Text(
                    "All Set!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your profile is complete.",
                    style: TextStyle(fontSize: 16),
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
      Navigator.of(context).pop(); // Close the dialog
      context.pushNamed(RouteNames.tdeeResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<UserProfileFormBloc, UserProfileFormState>(
            listener: (context, state) {
              if (state.isSuccess) {
                _showCelebrationDialog(context);
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SteppedProgressBar(
                          currentStep: 6,
                          totalSteps: 6,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Help us calculate your TDEE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "What's your Activity Level?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: ActivityLevel.values.map((activity) {
                                return Column(
                                  children: [
                                    _buildActivityButton(context, activity, state.activityLevel),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        NavigationButtons(
                          buttonText: "Finish",
                          onNextPressed: () {
                            if (state.activityLevel != null) {
                              context.read<UserProfileFormBloc>().add(SubmitForm());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select an activity level')),
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
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityButton(BuildContext context, ActivityLevel activity, ActivityLevel? selectedActivity) {
    bool isSelected = selectedActivity == activity;
    return GestureDetector(
      onTap: () {
        context.read<UserProfileFormBloc>().add(ActivityLevelChanged(activity));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activityDescriptions[activity]!,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}