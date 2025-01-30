import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/header_text.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/routes/route_names.dart';

class UserInfoScreenTwo extends StatefulWidget {
  const UserInfoScreenTwo({super.key});

  @override
  UserInfoScreenTwoState createState() => UserInfoScreenTwoState();
}

class UserInfoScreenTwoState extends State<UserInfoScreenTwo> {
  final TextEditingController ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileFormBloc>().add(const GenderChanged('Male'));
    });
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  void _handleNextButton(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<UserProfileFormBloc>();
      final state = bloc.state;

      if (state.gender == null || state.gender!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a gender')),
        );
      } else if (ageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your age')),
        );
      } else {
        bloc.add(AgeChanged(ageController.text));
        context.pushNamed(
          RouteNames.userInfoThree,
          extra: bloc,
        );
      }
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
        body: GradientContainer(
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress Bar
                            const SteppedProgressBar(
                              currentStep: 2,
                              totalSteps: 6,
                            ),

                            SizedBox(height: size.height * 0.04),

                            // Header
                            const HeaderTextDataScreen(
                              data: 'Tell Us About Yourself',
                            ),

                            SizedBox(height: size.height * 0.03),

                            // Gender Selection Text
                            Text(
                              "Please select your sex to help us to\ncalculate your calorie needs.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),

                            SizedBox(height: size.height * 0.02),

                            // Gender Selector
                            BlocBuilder<UserProfileFormBloc,
                                UserProfileFormState>(
                              builder: (context, state) {
                                return _buildGenderSelector(
                                    context, state.gender, size);
                              },
                            ),

                            SizedBox(height: size.height * 0.05),

                            // Age Section
                            Text(
                              "What's your Age?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: isSmallScreen ? 16 : 18,
                              ),
                            ),

                            SizedBox(height: size.height * 0.01),

                            // Age Input
                            BlocBuilder<UserProfileFormBloc,
                                UserProfileFormState>(
                              builder: (context, state) {
                                return CustomTextFormField(
                                  controller: ageController,
                                  onChanged: (value) {
                                    context
                                        .read<UserProfileFormBloc>()
                                        .add(AgeChanged(value));
                                  },
                                  keyboardType: TextInputType.phone,
                                  hintText: 'Enter Your Age',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid age (no dog years allowed! 🐕)';
                                    }
                                    final age = int.parse(value);
                                    if (age < 18) {
                                      return 'Sorry kiddo! Come back in ${18 - age} years when you\'re done with your homework 📚';
                                    }
                                    if (age > 120) {
                                      return 'Unless you\'re a vampire 🧛, please enter a realistic age!';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),

                            SizedBox(height: size.height * 0.01),

                            // Age Info Text
                            Text(
                              "Your age determines how much you should consume(age in year)",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Navigation Buttons
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: isKeyboardVisible ? viewInsets.bottom : 0,
                      ),
                      child: NavigationButtons(
                        onNextPressed: () => _handleNextButton(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(
      BuildContext context, String? selectedGender, Size size) {
    // final isSmallScreen = size.width < 360;

    return Container(
      height: size.height * 0.07,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors, width: 1),
      ),
      child: Row(
        children: [
          _buildGenderOption(context, 'Male', Icons.male, selectedGender, size),
          _buildGenderOption(
              context, 'Female', Icons.female, selectedGender, size),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    String gender,
    IconData icon,
    String? selectedGender,
    Size size,
  ) {
    final isSmallScreen = size.width < 360;
    final isSelected = selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.read<UserProfileFormBloc>().add(GenderChanged(gender)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.015,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.buttonColors : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 24 : 30,
                color: isSelected ? Colors.black : Colors.white,
              ),
              SizedBox(width: size.width * 0.01),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
