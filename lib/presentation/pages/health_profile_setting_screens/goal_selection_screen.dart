import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/citation_ibutton.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/routes/route_names.dart';

class GoalSelectionScreen extends StatefulWidget {
  final String currentWeight;
  const GoalSelectionScreen({super.key, required this.currentWeight});

  @override
  GoalSelectionScreenState createState() => GoalSelectionScreenState();
}

class GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

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

    if (gender.toLowerCase() == 'male') {
      minWeight += 3;
      maxWeight += 3;
    }

    return '${minWeight.toStringAsFixed(1)}-${maxWeight.toStringAsFixed(1)} ${isMetric ? 'kg' : 'lbs'}';
  }

  void _handleNextButton(BuildContext context, UserProfileFormState state) {
    if (_formKey.currentState?.validate() ?? false) {
      if (state.weightGoal != null) {
        if ((state.weightGoal == WeightGoal.lose ||
                state.weightGoal == WeightGoal.gain) &&
            weightController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your goal weight')),
          );
        } else {
          // If maintaining weight, skip the GoalPaceScreen
          if (state.weightGoal == WeightGoal.maintain) {
            context.pushNamed(
              RouteNames.dailyactivity,
              extra: context.read<UserProfileFormBloc>(),
            );
          } else {
            // For lose/gain weight, go to GoalPaceScreen
            context.pushNamed(
              RouteNames.goalPace,
              extra: context.read<UserProfileFormBloc>(),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a goal')),
        );
      }
    }
  }

  static const double underweightBmi = 18.5;
  static const double normalBmi = 24.9;
  static const double overweightBmi = 29.9;

  String getBmiCategory(double bmi) {
    if (bmi < underweightBmi) return 'underweight';
    if (bmi <= normalBmi) return 'normal';
    if (bmi <= overweightBmi) return 'overweight';
    return 'obese';
  }

  String getSuggestedGoal(double bmi) {
    final category = getBmiCategory(bmi);
    switch (category) {
      case 'underweight':
        return 'Based on your BMI, we suggest gaining weight to reach a healthier range.';
      case 'normal':
        return 'Your BMI is in a healthy range. We suggest maintaining your current weight.';
      case 'overweight':
      case 'obese':
        return 'Based on your BMI, we suggest losing weight to reach a healthier range.';
      default:
        return '';
    }
  }

  Color getGoalButtonBorderColor(WeightGoal goal, double bmi, bool isSelected) {
    if (isSelected) return AppColors.buttonColors;

    final category = getBmiCategory(bmi);
    if (goal == WeightGoal.lose && (category == 'underweight')) {
      return Colors.red;
    }
    if (goal == WeightGoal.gain &&
        (category == 'obese' || category == 'overweight')) {
      return Colors.red;
    }
    return Colors.grey[700]!;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.currentWeight);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
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
                idealWeightRange = getIdealWeightRange(
                    height, state.isMetric, state.gender ?? 'male');
              }
            } catch (e) {
              debugPrint('Error calculating BMI: $e');
            }

            return GradientContainer(
              top: size.height * 0.06,
              left: size.height * 0.01,
              right: size.height * 0.01,
              bottom: size.height * 0.01,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.02,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SteppedProgressBar(
                                  currentStep: 4,
                                  totalSteps: 6,
                                ),

                                SizedBox(height: size.height * 0.04),

                                Text(
                                  'Every step towards your goal is progress.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: size.height * 0.03),

                                // Text(
                                //   "What's your Goal ?",
                                //   style: TextStyle(
                                //     color: Colors.grey,
                                //     fontSize: isSmallScreen ? 14 : 16,
                                //   ),
                                // ),
                                if (bmi != null) ...[
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Your BMI: ${bmi.toStringAsFixed(1)}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        isSmallScreen ? 14 : 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                InfoButton(
                                                  compact: true,
                                                  metricType: 'bmi',
                                                  size: isSmallScreen ? 16 : 18,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          getSuggestedGoal(bmi),
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: isSmallScreen ? 12 : 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                ],

                                Text(
                                  "What's your Goal?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),

                                SizedBox(height: size.height * 0.01),

                                _buildGoalButton(
                                  context,
                                  WeightGoal.lose,
                                  'Lose Weight',
                                  size,
                                  bmi ?? 0,
                                ),
                                SizedBox(height: size.height * 0.01),
                                _buildGoalButton(
                                  context,
                                  WeightGoal.maintain,
                                  'Maintain Weight',
                                  size,
                                  bmi ?? 0,
                                ),
                                SizedBox(height: size.height * 0.01),
                                _buildGoalButton(
                                  context,
                                  WeightGoal.gain,
                                  'Gain Weight',
                                  size,
                                  bmi ?? 0,
                                ),
                                SizedBox(height: size.height * 0.02),

                                if (state.weightGoal == WeightGoal.lose ||
                                    state.weightGoal == WeightGoal.gain ||
                                    state.weightGoal == WeightGoal.maintain)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.weightGoal == WeightGoal.maintain
                                            ? "Confirm your maintenance weight:"
                                            : "What's your target weight?",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: isSmallScreen ? 14 : 16,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      if (bmi != null) ...[
                                        Text(
                                          'Based on your BMI of ${bmi.toStringAsFixed(1)}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: isSmallScreen ? 11 : 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Your ideal weight range is $idealWeightRange',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize:
                                                    isSmallScreen ? 11 : 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            // InfoButton(
                                            //   compact: true,
                                            //   metricType: 'weight_range',
                                            //   size: isSmallScreen ? 14 : 16,
                                            //   color: Colors.grey[600],
                                            // ),
                                          ],
                                        ),
                                      ],
                                      SizedBox(height: size.height * 0.01),
                                      CustomTextFormField(
                                        keyboardType: TextInputType.number,
                                        hintText: state.weightGoal ==
                                                WeightGoal.maintain
                                            ? 'Confirm your current weight (${state.isMetric ? 'kg' : 'lbs'})'
                                            : 'Input the goal weight (${state.isMetric ? 'kg' : 'lbs'})',
                                        controller: weightController,
                                        onChanged: (value) {
                                          context
                                              .read<UserProfileFormBloc>()
                                              .add(TargetWeightChanged(value));
                                        },
                                        validator: (value) =>
                                            validateTargetWeight(
                                                value,
                                                state.weightGoal,
                                                widget.currentWeight,
                                                state.isMetric),
                                      ),
                                    ],
                                  ),

                                // Extra space for keyboard
                                SizedBox(
                                  height: isKeyboardVisible
                                      ? size.height * 0.15
                                      : size.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Navigation Buttons
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          bottom: isKeyboardVisible
                              ? viewInsets.bottom
                              : size.height * 0.02,
                        ),
                        child: NavigationButtons(
                          onNextPressed: () =>
                              _handleNextButton(context, state),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoalButton(BuildContext context, WeightGoal goal, String label,
      Size size, double bmi) {
    return BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
      builder: (context, state) {
        final isSelected = state.weightGoal == goal;
        final borderColor = getGoalButtonBorderColor(goal, bmi, isSelected);
        final category = getBmiCategory(bmi);
        final showWarning =
            (goal == WeightGoal.lose && category == 'underweight') ||
                (goal == WeightGoal.gain &&
                    (category == 'obese' || category == 'overweight'));

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                if (showWarning) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[900],
                      title: Text('Health Consideration',
                          style: TextStyle(color: Colors.white)),
                      content: Text(
                          goal == WeightGoal.lose
                              ? 'Your BMI indicates you\'re underweight. Consider consulting a healthcare provider before starting a weight loss plan.'
                              : 'Your BMI indicates you\'re overweight/obese. Consider consulting a healthcare provider before starting a weight gain plan.',
                          style: TextStyle(color: Colors.grey[300])),
                      actions: [
                        TextButton(
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.grey)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text('Proceed',
                              style: TextStyle(color: AppColors.buttonColors)),
                          onPressed: () {
                            Navigator.pop(context);
                            context
                                .read<UserProfileFormBloc>()
                                .add(GoalChanged(goal));
                            if (goal == WeightGoal.maintain) {
                              weightController.text = widget.currentWeight;
                              context.read<UserProfileFormBloc>().add(
                                  TargetWeightChanged(widget.currentWeight));
                            } else {
                              weightController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  context.read<UserProfileFormBloc>().add(GoalChanged(goal));
                  if (goal == WeightGoal.maintain) {
                    weightController.text = widget.currentWeight;
                    context
                        .read<UserProfileFormBloc>()
                        .add(TargetWeightChanged(widget.currentWeight));
                  } else {
                    weightController.clear();
                  }
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? AppColors.buttonColors : Colors.white,
                      fontSize: size.width < 360 ? 14 : 16,
                    ),
                  ),
                ),
              ),
            ),
            if (showWarning)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Please consult a healthcare provider',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String? validateTargetWeight(
      String? value, WeightGoal? goal, String currentWeight, bool isMetric) {
    if (value == null || value.isEmpty) {
      return 'Please enter your goal weight';
    }

    if (!RegExp(r'^\d*\.?\d{0,1}$').hasMatch(value)) {
      return 'Please enter a valid number with up to 1 decimal place';
    }

    try {
      final targetWeight = double.parse(value);
      final currentWeightValue = double.parse(currentWeight);

      // Base validation
      if (targetWeight <= 0) return 'Weight must be greater than 0';

      // Metric system limits
      final minWeight = isMetric ? 30.0 : 66.0; // 30kg or 66lbs
      final maxWeight = isMetric ? 300.0 : 660.0; // 300kg or 660lbs

      if (targetWeight < minWeight) {
        return 'Target weight cannot be less than ${minWeight.toStringAsFixed(1)} ${isMetric ? "kg" : "lbs"}';
      }
      if (targetWeight > maxWeight) {
        return 'Target weight cannot exceed ${maxWeight.toStringAsFixed(1)} ${isMetric ? "kg" : "lbs"}';
      }

      // Goal-specific validation
      switch (goal) {
        case WeightGoal.lose:
          if (targetWeight >= currentWeightValue) {
            return 'Target weight must be less than current weight';
          }
          // Prevent extreme weight loss (more than 50% of current weight)
          if (targetWeight < currentWeightValue * 0.5) {
            return 'Please set a more realistic weight loss goal';
          }
          break;

        case WeightGoal.gain:
          if (targetWeight <= currentWeightValue) {
            return 'Target weight must be greater than current weight';
          }
          // Prevent extreme weight gain (more than 100% increase)
          if (targetWeight > currentWeightValue * 2) {
            return 'Please set a more realistic weight gain goal';
          }
          break;

        case WeightGoal.maintain:
          final tolerance = isMetric ? 0.1 : 0.2; // 0.1kg or 0.2lbs tolerance
          if ((targetWeight - currentWeightValue).abs() > tolerance) {
            return 'Please confirm your current weight';
          }
          break;
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } catch (e) {
      return 'Please enter a valid number';
    }

    return null;
  }
}
