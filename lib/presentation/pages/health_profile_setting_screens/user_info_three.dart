import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/Validation_const/validation_const.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/toggle_button.dart';
import 'package:hungrx_app/routes/route_names.dart';

class UserInfoScreenThree extends StatefulWidget {
  const UserInfoScreenThree({super.key});

  @override
  UserInfoScreenThreeState createState() => UserInfoScreenThreeState();
}

class UserInfoScreenThreeState extends State<UserInfoScreenThree> {
  final FocusNode _feetFocusNode = FocusNode();
  final FocusNode _inchesFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _hightFocusNode = FocusNode();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double sliderValue = 1;

  @override
  void dispose() {
    _feetFocusNode.dispose();
    _inchesFocusNode.dispose();
    _weightFocusNode.dispose();
    _hightFocusNode.dispose();
    heightController.dispose();
    weightController.dispose();
    inchesController.dispose();
    super.dispose();
  }

  void _handleNextButton(BuildContext context, UserProfileFormState state) {
    if (_formKey.currentState?.validate() ?? false) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final bloc = context.read<UserProfileFormBloc>();
        if (state.isMetric) {
          bloc.add(HeightChanged(heightController.text));
        } else {
          bloc.add(HeightFeetChanged(heightController.text));
          bloc.add(HeightInchesChanged(inchesController.text));
        }
        bloc.add(WeightChanged(weightController.text));
        context.pushNamed(RouteNames.goalSelection,
            queryParameters: {'currentWeight': weightController.text},
            extra: bloc);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        child: LayoutBuilder(builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Progress Bar
                                  const SteppedProgressBar(
                                    currentStep: 3,
                                    totalSteps: 6,
                                  ),

                                  SizedBox(height: size.height * 0.04),

                                  // Header Text
                                  Text(
                                    'Help Us Calculate Your\nTDEE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 24 : 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.02),

                                  // Meals per day section
                                  Text(
                                    "How many times do you typically\neat in a day?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.01),

                                  // Slider
                                  SizedBox(
                                    height: size.height * 0.05,
                                    child: ValueListenableBuilder<double>(
                                      valueListenable: ValueNotifier(
                                          state.mealsPerDay ?? 1.0),
                                      builder: (context, value, child) {
                                        return Slider(
                                          value: value,
                                          min: 1,
                                          max: 4,
                                          divisions: 3,
                                          activeColor: AppColors.buttonColors,
                                          inactiveColor: Colors.grey[800],
                                          label: value.toString(),
                                          onChanged: (newValue) {
                                            SchedulerBinding.instance
                                                .addPostFrameCallback((_) {
                                              context
                                                  .read<UserProfileFormBloc>()
                                                  .add(MealsPerDayChanged(
                                                      newValue));
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  // Slider labels
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.05,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [1, 2, 3, 4]
                                          .map((e) => Text(
                                                e.toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      isSmallScreen ? 12 : 14,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.04),

                                  // Measurement System
                                  Text(
                                    "Select Measurement System",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.02),

                                  // Unit Toggle
                                  UnitToggle(
                                    isMetric: state.isMetric,
                                    onToggle: (value) {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        context
                                            .read<UserProfileFormBloc>()
                                            .add(UnitChanged(value));
                                      });
                                    },
                                  ),

                                  SizedBox(height: size.height * 0.03),

                                  // Height Section
                                  Text(
                                    "What's your Height?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.01),

                                  // Height Input Fields
                                  if (state.isMetric)
                                    CustomTextFormField(
                                      controller: heightController,
                                      hintText: 'Enter Your Height (cm)',
                                      keyboardType: TextInputType.number,
                                      focusNode: _hightFocusNode,
                                      maxLength: 3,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_weightFocusNode);
                                      },
                                      onChanged: (value) {
                                        SchedulerBinding.instance
                                            .addPostFrameCallback((_) {
                                          context
                                              .read<UserProfileFormBloc>()
                                              .add(HeightChanged(value));
                                        });
                                      },
                                      validator: (value) =>
                                          validateMetricHeight(value),
                                    )
                                  else
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller: heightController,
                                            hintText: 'Feet',
                                            keyboardType: TextInputType.number,
                                            focusNode: _feetFocusNode,
                                            maxLength: 1,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _inchesFocusNode);
                                            },
                                            onChanged: (value) {
                                              context
                                                  .read<UserProfileFormBloc>()
                                                  .add(
                                                      HeightFeetChanged(value));
                                            },
                                            validator: (value) =>
                                                validateImperialHeightFeet(
                                                    value),

                                            // (value) {
                                            //   if (value == null ||
                                            //       value.isEmpty) {
                                            //     return 'Required';
                                            //   }
                                            //   return null;
                                            // },
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller: inchesController,
                                            hintText: 'Inches',
                                            keyboardType: TextInputType.number,
                                            focusNode: _inchesFocusNode,
                                            maxLength: 2,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _weightFocusNode);
                                            },
                                            onChanged: (value) {
                                              context
                                                  .read<UserProfileFormBloc>()
                                                  .add(HeightInchesChanged(
                                                      value));
                                            },
                                            validator: (value) =>
                                                validateImperialHeightInches(
                                                    value),
                                          ),
                                        ),
                                      ],
                                    ),

                                  SizedBox(height: size.height * 0.02),

                                  // Weight Section
                                  Text(
                                    "What's your Weight?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),

                                  SizedBox(height: size.height * 0.01),

                                  // Weight Input
                                  CustomTextFormField(
                                    controller: weightController,
                                    hintText: state.isMetric
                                        ? 'Enter Your Weight (kg)'
                                        : 'Enter Your Weight (lbs)',
                                    keyboardType: TextInputType.number,
                                    focusNode: _weightFocusNode,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      _weightFocusNode.unfocus();
                                      _handleNextButton(context, state);
                                    },
                                    onChanged: (value) {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        validateWeight(value, state.isMetric);
                                      });
                                    },
                                    validator: (value) =>
                                        validateWeight(value, state.isMetric),
                                  ),

                                  // Extra space at bottom for keyboard
                                  SizedBox(
                                      height: isKeyboardVisible
                                          ? size.height * 0.15
                                          : size.height * 0.05),
                                ],
                              ),
                            ),
                          );
                        }),
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

  String? validateMetricHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your height';
    }

    // Check if input is numeric
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
      return 'Please enter a valid number';
    }

    double? height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }

    if (height < ValidationConstants.minHeightCm) {
      return 'Height cannot be less than ${ValidationConstants.minHeightCm} cm';
    }

    if (height > ValidationConstants.maxHeightCm) {
      return 'Height cannot exceed ${ValidationConstants.maxHeightCm} cm';
    }

    return null;
  }

  String? validateImperialHeightFeet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    // Check if input is numeric and whole number
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Enter whole numbers only';
    }

    int? feet = int.tryParse(value);
    if (feet == null) {
      return 'Enter a valid number';
    }

    if (feet < ValidationConstants.minHeightFeet) {
      return 'Min ${ValidationConstants.minHeightFeet} ft';
    }

    if (feet > ValidationConstants.maxHeightFeet) {
      return 'Max ${ValidationConstants.maxHeightFeet} ft';
    }

    return null;
  }

  String? validateImperialHeightInches(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    // Check if input is numeric and whole number
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Enter whole numbers only';
    }

    int? inches = int.tryParse(value);
    if (inches == null) {
      return 'Enter a valid number';
    }

    if (inches < ValidationConstants.minHeightInches) {
      return 'Min 0 inches';
    }

    if (inches > ValidationConstants.maxHeightInches) {
      return 'Max 11 inches';
    }

    return null;
  }

// Weight validation functions
  String? validateWeight(String? value, bool isMetric) {
    if (value == null || value.isEmpty) {
      return 'Please enter your weight';
    }

    if (!RegExp(r'^\d*\.?\d{0,1}$').hasMatch(value)) {
      return 'Please enter a valid number with up to 1 decimal place';
    }

    double? weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }

    if (isMetric) {
      if (weight < ValidationConstants.minWeightKg) {
        return 'Weight cannot be less than ${ValidationConstants.minWeightKg} kg';
      }
      if (weight > ValidationConstants.maxWeightKg) {
        return 'Weight cannot exceed ${ValidationConstants.maxWeightKg} kg';
      }
    } else {
      if (weight < ValidationConstants.minWeightLbs) {
        return 'Weight cannot be less than ${ValidationConstants.minWeightLbs} lbs';
      }
      if (weight > ValidationConstants.maxWeightLbs) {
        return 'Weight cannot exceed ${ValidationConstants.maxWeightLbs} lbs';
      }
    }

    return null;
  }
}
