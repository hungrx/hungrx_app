import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/routes/route_names.dart';

class GoalPaceScreen extends StatelessWidget {
  const GoalPaceScreen({super.key});

  void _validateAndNavigate(BuildContext context, UserProfileFormState state) {

    final currentWeight = double.tryParse(state.weight) ?? 0;
    final targetWeight = double.tryParse(state.targetWeight ?? '') ?? 0;
    final weeklyPace = _calculateWeeklyPace(state.weightPace??2.0, state.isMetric);


    final weightDifference = (targetWeight - currentWeight).abs();
    final weeksToGoal = (weightDifference / weeklyPace).ceil();
    final monthsToGoal = (weeksToGoal / 4).ceil();

    if (monthsToGoal > 24) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Long-Term Goal', style: TextStyle(color: Colors.white)),
          content: Text(
            'This goal will take over 2 years to achieve. Consider adjusting your target weight or choosing a faster pace.',
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              child: Text('Adjust Goal', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Proceed Anyway', style: TextStyle(color: AppColors.buttonColors)),
              onPressed: () {
                Navigator.pop(context);
                context.pushNamed(RouteNames.dailyactivity);
              },
            ),
          ],
        ),
      );
      return;
    }

    context.pushNamed(RouteNames.dailyactivity);
  }

  double _calculateWeeklyPace(double paceValue, bool isMetric) {
  
    return (paceValue - 1) * (isMetric ? 0.25 : 0.5) + (isMetric ? 0.25 : 0.5);
  }

  String _getPaceText(WeightGoal? goal, double paceValue, bool isMetric) {
    if (goal == WeightGoal.maintain) {
      return '0 ${isMetric ? 'kg' : 'lbs'}';
    }
    final pace = _calculateWeeklyPace(paceValue, isMetric);
    return '${pace.toStringAsFixed(2)} ${isMetric ? 'kg' : 'lbs'}';
  }

  String _getEstimatedTimeToGoal(
    WeightGoal? goal,
    double paceValue,
    double currentWeight,
    double goalWeight,
    bool isMetric,
  ) {
    if (goal == WeightGoal.maintain) return "";
    if (currentWeight <= 0 || goalWeight <= 0) return "Invalid weight values";

    final weeklyPace = _calculateWeeklyPace(paceValue, isMetric);
    if (weeklyPace == 0) return "Invalid pace selected";

    final weightDifference = (goalWeight - currentWeight).abs();
    final weeksToGoal = (weightDifference / weeklyPace).ceil();
    final monthsToGoal = (weeksToGoal / 4).ceil();

    // Maximum safe monthly weight change
    final maxMonthlyChange = isMetric ? 4.0 : 8.8; // 4kg or 8.8lbs per month
    final actualMonthlyChange = weightDifference / monthsToGoal;
    
    if (actualMonthlyChange > maxMonthlyChange) {
      return "Warning: This pace may be too aggressive for healthy progress";
    }

    return monthsToGoal < 1 
      ? "Expected time: Less than a month"
      : "Expected time: About $monthsToGoal month${monthsToGoal > 1 ? 's' : ''}";
  }

  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
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
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SteppedProgressBar(
                              currentStep: 5,
                              totalSteps: 6,
                            ),

                            SizedBox(height: size.height * 0.04),

                            // Title
                            Text(
                              _getTitle(state.weightGoal),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 22 : 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: size.height * 0.02),

                            // Suggestion Text
                            Text(
                              _getSuggestion(state.weightPace ?? 2.0),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: size.height * 0.06),

                            // Pace Display
                            Center(
                              child: Text(
                                _getPaceText(
                                  state.weightGoal,
                                  state.weightPace ?? 2.0,
                                  state.isMetric,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 42 : 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Center(
                              child: Text(
                                'per week',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.01),

                            // Slider
                            SizedBox(
                              height: size.height * 0.05,
                              child: Slider(
                                value: state.weightPace ?? 2.0,
                                min: 1,
                                max: 3,
                                divisions: 2,
                                activeColor: AppColors.buttonColors,
                                inactiveColor: Colors.grey[800],
                                onChanged: (value) {
                                  context
                                      .read<UserProfileFormBloc>()
                                      .add(WeightPaceChanged(value));
                                },
                              ),
                            ),

                            // Pace Labels
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _getPaceLabels(
                                  state.weightGoal,
                                  isSmallScreen,
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.05),

                            // Estimated Time Container
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                  vertical: size.height * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: state.weightGoal == WeightGoal.maintain
                                      ? Colors.transparent
                                      : const Color.fromARGB(255, 49, 54, 43),
                                ),
                                child: Text(
                                  _getEstimatedTimeToGoal(
                                    state.weightGoal,
                                    state.weightPace ?? 2.0,
                                    double.tryParse(state.weight) ?? 0,
                                    double.tryParse(
                                            state.targetWeight ?? '0') ??
                                        0,
                                        state.isMetric
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.03),
                          ],
                        ),
                      ),
                    ),

                    // Navigation Buttons
                    NavigationButtons(
                      onNextPressed: () => _validateAndNavigate(context, state),
                      // onNextPressed: () {
                      //   print(state.weightPace);
                      //   context.pushNamed(RouteNames.dailyactivity);
                      // },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTitle(WeightGoal? goal) {
    switch (goal) {
      case WeightGoal.lose:
        return 'How fast do you want to\nlose weight?';
      case WeightGoal.gain:
        return 'How fast do you want to\ngain weight?';
      case WeightGoal.maintain:
        return 'Maintain your current\nweight';
      default:
        return 'Select your weight goal';
    }
  }

  // String _getPaceText(WeightGoal? goal, double paceValue) {
  //   if (goal == WeightGoal.maintain) {
  //     return '0 Kg';
  //   }
  //   double pace = (paceValue - 1) * 0.25 + 0.25;
  //   return '${pace.toStringAsFixed(2)} Kg';
  // }

  List<Widget> _getPaceLabels(WeightGoal? goal, bool isSmallScreen) {
    if (goal == WeightGoal.maintain) {
      return [
        Text(
          'Maintain',
          style: TextStyle(
            color: Colors.grey,
            fontSize: isSmallScreen ? 12 : 14,
          ),
        )
      ];
    }

    return [
      'Mild',
      'Moderate',
      'Fast',
    ]
        .map((e) => Text(
              e,
              style: TextStyle(
                color: Colors.grey,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ))
        .toList();
  }

  String _getSuggestion(double paceValue) {
    switch (paceValue.toInt()) {
      case 1:
        return "This is a slow but very sustainable pace to reach your goal weight.";
      case 2:
        return "This is a good, sustainable pace to reach your goal weight.";
      case 3:
        return "This is a challenging but achievable pace. Make sure to stay consistent!";
      case 4:
        return "This is a very fast pace. It may be difficult to maintain. Consider a slower pace for long-term success.";
      default:
        return "";
    }
  }

  // String _getEstimatedTimeToGoal(
  //   WeightGoal? goal,
  //   double paceValue,
  //   double currentWeight,
  //   double goalWeight,
  // ) {
  //   if (goal == WeightGoal.maintain) {
  //     return "";
  //   }

  //   double weeklyPace = (paceValue - 1) * 0.25 + 0.25;
  //   double weightDifference = (goalWeight - currentWeight).abs();
  //   int weeksToGoal = (weightDifference / weeklyPace).ceil();
  //   int monthsToGoal = (weeksToGoal / 4).ceil();

  //   if (monthsToGoal < 1) {
  //     return "You can expect to reach your goal in less than a month!";
  //   } else if (monthsToGoal == 1) {
  //     return "You can expect to reach your goal in about 1 month.";
  //   } else {
  //     return "You can expect to reach your goal in about $monthsToGoal months.";
  //   }
  // }
}
