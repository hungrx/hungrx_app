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
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/toggle_button.dart';
import 'package:hungrx_app/routes/route_names.dart';

class UserInfoScreenThree extends StatefulWidget {
  const UserInfoScreenThree({super.key});

  @override
  UserInfoScreenThreeState createState() => UserInfoScreenThreeState();
}

class UserInfoScreenThreeState extends State<UserInfoScreenThree> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    inchesController.dispose();
    super.dispose();
  }

  void _handleNextButton(BuildContext context, UserProfileFormState state) {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<UserProfileFormBloc>();
      if (state.isMetric) {
        bloc.add(HeightChanged(heightController.text));
      } else {
        bloc.add(HeightFeetChanged(heightController.text));
        bloc.add(HeightInchesChanged(inchesController.text));
      }
      bloc.add(WeightChanged(weightController.text));
      context.pushNamed(RouteNames.goalSelection, extra: bloc);
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
                        child: SingleChildScrollView(
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
                                  child: Slider(
                                    value: state.mealsPerDay ?? 1,
                                    min: 1,
                                    max: 4,
                                    divisions: 3,
                                    activeColor: AppColors.buttonColors,
                                    inactiveColor: Colors.grey[800],
                                    label: state.mealsPerDay?.toString(),
                                    onChanged: (value) {
                                      context.read<UserProfileFormBloc>()
                                          .add(MealsPerDayChanged(value));
                                    },
                                  ),
                                ),
                                
                                // Slider labels
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [1, 2, 3, 4].map((e) => Text(
                                      e.toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    )).toList(),
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
                                    context.read<UserProfileFormBloc>()
                                        .add(UnitChanged(value));
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
                                    onChanged: (value) {
                                      context.read<UserProfileFormBloc>()
                                          .add(HeightChanged(value));
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your height';
                                      }
                                      return null;
                                    },
                                  )
                                else
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          controller: heightController,
                                          hintText: 'Feet',
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            context.read<UserProfileFormBloc>()
                                                .add(HeightFeetChanged(value));
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                        child: CustomTextFormField(
                                          controller: inchesController,
                                          hintText: 'Inches',
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            context.read<UserProfileFormBloc>()
                                                .add(HeightInchesChanged(value));
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Required';
                                            }
                                            return null;
                                          },
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
                                  onChanged: (value) {
                                    context.read<UserProfileFormBloc>()
                                        .add(WeightChanged(value));
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your weight';
                                    }
                                    return null;
                                  },
                                ),
                                
                                // Extra space at bottom for keyboard
                                SizedBox(height: isKeyboardVisible 
                                    ? size.height * 0.15 
                                    : size.height * 0.05),
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
                          bottom: isKeyboardVisible ? viewInsets.bottom : size.height * 0.02,
                        ),
                        child: NavigationButtons(
                          onNextPressed: () => _handleNextButton(context, state),
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
}