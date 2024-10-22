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
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileFormBloc>().add(const GenderChanged('Male'));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GradientContainer(
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
                          currentStep: 2,
                          totalSteps: 6,
                        ),
                        const SizedBox(height: 40),
                        const HeaderTextDataScreen(
                          data: 'Tell Us About Yourself',
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Please select which sex we should use to\ncalculate your calorie needs.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
                          builder: (context, state) {
                            return _buildGenderSelector(context, state.gender);
                          },
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          "What's your Age?",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
                            builder: (context, state) {
                          return CustomTextFormField(
                              controller: ageController,
                              onChanged: (value) {
                                context
                                    .read<UserProfileFormBloc>()
                                    .add(AgeChanged(value));
                              },
                              keyboardType: TextInputType.phone,
                              hintText: 'Enter Your Age');
                        }),
                        const SizedBox(height: 10),
                        const Text(
                          "Your age determines how much you should consume(age in year)",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        // const Spacer(),
                        
                      ],
                    ),
                  ),
                ),
                NavigationButtons(
                        onNextPressed: () {
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
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(BuildContext context, String? selectedGender) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors, width: 1),
      ),
      child: Row(
        children: [
          _buildGenderOption(context, 'Male', Icons.male, selectedGender),
          _buildGenderOption(context, 'Female', Icons.female, selectedGender),
        ],
      ),
    );
  }

  Widget _buildGenderOption(BuildContext context, String gender, IconData icon,
      String? selectedGender) {
    bool isSelected = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.read<UserProfileFormBloc>().add(GenderChanged(gender)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
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
                size: 30,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}