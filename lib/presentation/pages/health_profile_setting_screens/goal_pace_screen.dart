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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                padding: const EdgeInsets.all(20.0),
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
                            const SizedBox(height: 40),
                            Text(
                              _getTitle(state.weightGoal),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _getSuggestion(state.weightPace ?? 2.0),
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 60),
                            Center(
                              child: Text(
                                _getPaceText(
                                    state.weightGoal, state.weightPace ?? 2.0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Center(
                              child: Text(
                                'per week',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Slider(
                              value: state.weightPace ?? 2.0,
                              min: 1,
                              max: 4,
                              divisions: 3,
                              activeColor: AppColors.buttonColors,
                              inactiveColor: Colors.grey[800],
                              onChanged: (value) {
                                context
                                    .read<UserProfileFormBloc>()
                                    .add(WeightPaceChanged(value));
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _getPaceLabels(state.weightGoal),
                            ),
                           const SizedBox(height: 50),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: state.weightGoal == WeightGoal.maintain
                                      ? Colors.transparent
                                      : const Color.fromARGB(255, 49, 54, 43),
                                ),
                                child: Text(
                                  _getEstimatedTimeToGoal(
                                    state.weightGoal,
                                    state.weightPace ?? 2.0,
                                    double.tryParse(state.weight)??0,
                                    double.tryParse(
                                            state.targetWeight ?? '0') ??
                                        0,
                                  ),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    NavigationButtons(
                      onNextPressed: () {
                        context.pushNamed(RouteNames.dailyactivity);
                      },
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

  String _getPaceText(WeightGoal? goal, double paceValue) {
    if (goal == WeightGoal.maintain) {
      return '0 Kg';
    }
    double pace = (paceValue - 1) * 0.25 + 0.25; // 0.25, 0.5, 0.75, or 1 kg
    return '${pace.toStringAsFixed(2)} Kg';
  }

  List<Widget> _getPaceLabels(WeightGoal? goal) {
    if (goal == WeightGoal.maintain) {
      return [const Text('Maintain', style: TextStyle(color: Colors.grey))];
    }
    return ['Mild', 'Moderate', 'Fast', 'Very Fast']
        .map((e) => Text(
              e,
              style: const TextStyle(color: Colors.grey),
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

  String _getEstimatedTimeToGoal(WeightGoal? goal, double paceValue,
      double currentWeight, double goalWeight) {
    if (goal == WeightGoal.maintain) {
      return "";
    }

    double weeklyPace = (paceValue - 1) * 0.25 + 0.25;
    double weightDifference = (goalWeight - currentWeight).abs();
    int weeksToGoal = (weightDifference / weeklyPace).ceil();
    int monthsToGoal = (weeksToGoal / 4).ceil();

    if (monthsToGoal < 1) {
      return "You will reach your goal in less than a month!";
    } else if (monthsToGoal == 1) {
      return "You will reach your goal in about 1 month.";
    } else {
      return "You will reach your goal in about $monthsToGoal months.";
    }
  }
}
