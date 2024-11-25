import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/routes/route_names.dart';



class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  GoalSelectionScreenState createState() => GoalSelectionScreenState();
}

class GoalSelectionScreenState extends State<GoalSelectionScreen> {
  TextEditingController weightController = TextEditingController();

  double calculateBMI(double height, double weight, bool isMetric) {
    if (isMetric) {
      return weight / ((height / 100) * (height / 100));
    } else {
      return (weight / (height * height)) * 703;
    }
  }

  String getIdealWeightRange(double height, bool isMetric, String gender) {
    double minWeight, maxWeight;
    if (isMetric) {
      minWeight = (18.5 * (height / 100) * (height / 100)).roundToDouble();
      maxWeight = (24.9 * (height / 100) * (height / 100)).roundToDouble();
    } else {
      minWeight = ((18.5 * (height * height)) / 703).roundToDouble();
      maxWeight = ((24.9 * (height * height)) / 703).roundToDouble();
    }
    
    // Adjust for gender
    if (gender.toLowerCase() == 'male') {
      minWeight += 3;
      maxWeight += 3;
    }

    return '${minWeight.toStringAsFixed(1)}-${maxWeight.toStringAsFixed(1)} ${isMetric ? 'kg' : 'lbs'}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
        builder: (context, state) {
          double? height;
          double? weight;
          double? bmi;
          String idealWeightRange = '';

          try {
            if (state.isMetric) {
              height = double.tryParse(state.heightInCm) ?? 0;
            } else {
              double feet = double.tryParse(state.heightFeet) ?? 0;
              double inches = double.tryParse(state.heightInches) ?? 0;
              height = (feet * 12) + inches;
            }

            weight = double.tryParse(state.weight) ?? 0;

            if (height > 0 && weight > 0) {
              bmi = calculateBMI(height, weight, state.isMetric);
              idealWeightRange = getIdealWeightRange(height, state.isMetric, state.gender ?? 'male');
            }
          } catch (e) {
            throw('Error calculating BMI: $e');
          }
          return GradientContainer(
            top: size.height * 0.06,
            left: size.height * 0.01,
            right: size.height * 0.01,
            bottom: size.height * 0.01,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SteppedProgressBar(
                              currentStep: 4,
                              totalSteps: 6,
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Every step towards your goal is progress.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "What's your Goal ?",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            _buildGoalButton(context, WeightGoal.lose, 'Lose Weight'),
                            const SizedBox(height: 10),
                            _buildGoalButton(context, WeightGoal.maintain, 'Maintain Weight'),
                            const SizedBox(height: 10),
                            _buildGoalButton(context, WeightGoal.gain, 'Gain Weight'),
                            const SizedBox(height: 20),
                            if (state.weightGoal == WeightGoal.lose || state.weightGoal == WeightGoal.gain)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "What's is your target weight?",
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Based on your BMI of ${bmi!.toStringAsFixed(1)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    'Your ideal weight range is $idealWeightRange',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    keyboardType: TextInputType.number,
                                    hintText: 'Input the goal weight (${state.isMetric ? 'kg' : 'lbs'})',
                                    controller: weightController,
                                    onChanged: (value) {
                                      context.read<UserProfileFormBloc>().add(TargetWeightChanged(value));
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NavigationButtons(
                      onNextPressed: () {
                        if (state.weightGoal != null) {
                          if ((state.weightGoal == WeightGoal.lose || state.weightGoal == WeightGoal.gain) && weightController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter your goal weight')),
                            );
                          } else {
                            context.pushNamed(
                              RouteNames.goalPace,
                              extra: context.read<UserProfileFormBloc>(),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a goal')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalButton(BuildContext context, WeightGoal goal, String label) {
    return BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<UserProfileFormBloc>().add(GoalChanged(goal));
            if (goal == WeightGoal.maintain) {
              weightController.clear();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: state.weightGoal == goal ? AppColors.buttonColors : Colors.grey[700]!,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: state.weightGoal == goal ? AppColors.buttonColors : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}